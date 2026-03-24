# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t dockertest .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name dockertest dockertest

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.8

# Note that we are pinning debian to trixie (13) here to ensure consistent builds. We could use
# -slim and let it track latest stable, but that might lead to unexpected breakages.
# However note that as we are using the bookworm deb for wkhtmltopdf below and this means
# wkhtmltopdf might break if dependencies change so need to keep an eye on it.
FROM docker.io/library/ruby:$RUBY_VERSION-slim-trixie AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips libpq-dev && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment variables and enable jemalloc for reduced memory usage and latency.
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

ENV DEBIAN_FRONTEND=noninteractive

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# Install application gems
COPY Gemfile Gemfile.lock yarn.lock package.json .gemrc .ruby-version ./

ARG BUNDLE_GITHUB__COM
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
    bundle exec bootsnap precompile -j 1 --gemfile

# Copy into the build image only the files that are required to install gems and precompile assets.
# We could just do `COPY . $RAILS_ROOT/` to copy all files across but then if, say, only a ruby file
# has changed, and this change would not normally affect the output of assets:precompile or bundle
# install, those 2 tasks would nevertheless be re-run again by Docker because it has noticed that
# the content of the COPY content has changed and so everything after that has to be ru-run.
# This is why we cherry-pick files carefully here.
COPY ./Rakefile Rakefile
COPY ./app/models/application_record.rb ./app/models/application_record.rb
COPY ./app/assets ./app/assets
COPY ./db ./db

# We must copy every path that tailwind is configured to search when trying to purge
# unused css classes. See the paths in tailwind.config.js.
# COPY ./app ./app
# COPY ./bin ./bin
# COPY ./lib ./lib
# COPY ./packs ./packs
# COPY ./config ./config
# COPY ./config.ru ./
# COPY ./rollup.config.js ./rollup.config.js
#
COPY . .

# Precompile bootsnap code for faster boot times.
# -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
RUN bundle exec bootsnap precompile -j 1 app/ lib/
ENV RAILS_ENV="production"
ARG ASSET_CACHE_BUSTER=1
# Precompile assets from a clean slate so stale manifest files cannot leak into the image.
# This also ensures tailwind.css is generated before Sprockets compiles and fingerprints assets.
RUN rm -rf public/assets tmp/cache/assets && \
    echo "ASSET_CACHE_BUSTER=${ASSET_CACHE_BUSTER}" && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails tailwindcss:build --trace && \
    test -f app/assets/builds/tailwind.css && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile --trace && \
    ls -la public/assets && \
    ruby -rjson -e 'manifest = Dir["public/assets/.sprockets-manifest-*.json"].max or abort("missing sprockets manifest"); assets = JSON.parse(File.read(manifest)).fetch("assets"); abort("tailwind.css missing from asset manifest") unless assets.key?("tailwind.css"); puts "tailwind asset => #{assets.fetch("tailwind.css")}"'


# Final stage for app image
FROM base

# Make sure MS fonts installer does not halt on eula acceptance
# RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
# ttf-mscorefonts-installer
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y ldap-utils locales telnet curl wget ghostscript file tzdata nano unzip postgresql-client openssh-server gosu && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Uncomment to install network troubleshooting tools
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#       dnsutils \
#       iputils-ping \
#       netcat-openbsd && \
#     rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf from official .deb multi-arch build.
# ie will build cleanly for:
# --platform=linux/amd64 → downloads ..._amd64.deb
# --platform=linux/arm64 → downloads ..._arm64.deb
ARG WKHTMLTOX_VER=0.12.6.1-3
ARG TARGETARCH
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64|arm64) wk_arch="${TARGETARCH}" ;; \
      *) echo "Unsupported TARGETARCH=${TARGETARCH}"; exit 1 ;; \
    esac; \
    wget -O /tmp/wkhtmltox.deb \
      "https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOX_VER}/wkhtmltox_${WKHTMLTOX_VER}.bookworm_${wk_arch}.deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/wkhtmltox.deb; \
    rm -f /tmp/wkhtmltox.deb; \
    rm -rf /var/lib/apt/lists/*

# Add REVISION file with git short hash and build timestamp
# This can be used by the application to report version info
# GIT_VERSION_TAG is passed in at build time in GH workflow build.yml
# eg
# $ghcr.io/airslie/renalware-ich:2.4.5-sha.8d86096.ts.20251223143613
ARG GITHUB_SHA
RUN ["/bin/bash", "-c", "echo \"${GITHUB_SHA:0:7}\" > ./REVISION"]

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --home-dir /home/rails --shell /bin/bash && \
    mkdir -p /home/rails && chown -R rails:rails /home/rails
ENV HOME=/home/rails
USER rails

# In an Azure App Service, /home is reserved for a special mount (when the app starts it will say
# home/rails is not a valid directory) so our rails user's home dir is a bit redundant but we
# we keep it there for good form. Note $HOME is also reserved.
# However it creates problems with bundler which wants
# to create $HOME/.bundle => /home/rails/.bundle - which it cannot resolved.
# So for clarity we set BUNDLE_USER_HOME to a known location that is writeable.
ENV BUNDLE_USER_HOME=/tmp/bundle

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

ENV RAILS_ENV="production"
ENV RAILS_SERVE_STATIC_FILES="1"

EXPOSE 3000
EXPOSE 2222

# chmod/chown is cleanest as root
USER root
COPY --chown=rails:rails docker_entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sshd_config.azure /etc/ssh/sshd_config.d/azure-app-service.conf
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
