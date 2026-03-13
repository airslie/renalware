# Renalware Release and Deployment Strategy

## Overview

Renalware is now a single Rails application, configured per environment. The goal of this model
is to keep the codebase unified while allowing different hospitals to run different supported
versions of the application.

This approach is designed to provide:

* a single primary source code repository
* clear traceability between Git commits, app versions, Docker images, and deployments
* support for multiple hospital environments running different release lines
* a safe way to patch older supported versions without forcing every hospital to upgrade immediately

## Core Principles

### 1. One application repo

Renalware should live in a single main Git repository.

Hospitals should **not** have long-lived code branches such as `ich`, `mse`, `blt`, or `dvh` unless there is a truly unavoidable code fork. In general, hospitals should differ by configuration, not by source code.

### 2. Main branch for ongoing development

Use:

* `main` for ongoing development and the demo environment
* short-lived branches such as `feature/...`, `fix/...`, or `hotfix/...` for individual changes

Changes are merged back into `main` in the normal way.

### 3. Release branches for supported production lines

Create release branches only for production versions that need ongoing support, for example:

* `release/2.5`
* `release/2.7`

These branches exist so that hospitals can remain on an older supported version while still receiving important fixes such as security patches or critical bug fixes.

### 4. Git tags define actual releases

Use annotated Git tags for actual releases, for example:

* `v2.5.0`
* `v2.5.1`
* `v2.7.0`

Tags represent released application versions. They should be the main reference point for production deployments.

## Docker Image Strategy

Each build should produce immutable Docker images with tags that make both human and machine tracing easy.

Recommended tags for a release build:

* `2.5.2`
* `2.5`
* `sha-<gitsha>`

Recommended tags for a `main` build:

* `main`
* `main-YYYYMMDD-HHMM`
* `sha-<gitsha>`

Important rules:

* Docker images should be built once and then promoted across environments where possible
* deployments should ideally reference the image **digest** rather than just a mutable tag
* every image should carry metadata such as app version, Git SHA, source repo, and build time

## Deployment Model

Hospitals are pinned to **released versions**, not to branches.

For example:

* demo may track `main`
* ICH may run `2.5.2`
* MSE may run `2.7.3`
* BLT may run `2.7.3`
* DVH may run `2.7.1`

This makes it possible to answer:

* which hospital is on which version?
* which Git commit produced that version?
* which Docker image digest is running in each environment?

Keep an explicit deployment matrix in infrastructure/configuration, not just in people’s heads.

## Patching Older Versions

If a hospital remains on an older supported release line, fixes should normally be applied as follows:

1. implement and test the fix on `main`
2. cherry-pick the fix onto each supported release branch that needs it
3. create a new patch release tag on each affected release line
4. build and publish corresponding Docker images
5. deploy only the relevant patched image to the relevant hospitals

Example:

* ICH is on `2.5.x`
* other hospitals are on `2.7.x`
* a security issue affects both

Then:

* fix on `main`
* backport to `release/2.7` and `release/2.5`
* release `v2.7.4` and `v2.5.3`
* deploy `2.5.3` to ICH and `2.7.4` to the others

This avoids forcing a hospital onto a newer feature release just to receive a critical patch.

## Configuration vs Customisation

Hospital differences should be handled in this order of preference:

1. environment variables and secrets
2. database-stored site configuration
3. feature flags or capability flags
4. small isolated conditional code where absolutely unavoidable

The preferred model is one shared codebase and one shared image artifact, with behaviour adjusted by configuration.

## Recommended Policy

In summary:

* use one main Renalware application repository
* use `main` for development and demo
* use short-lived working branches for changes
* create release branches only for supported production lines
* tag every release in Git
* tag every Docker image with both version and Git SHA
* embed build metadata into images and, ideally, expose it from the running app
* deploy by image digest where possible
* maintain a deployment matrix showing hospital, version, image digest, and Git SHA
* support only a limited number of release lines at once

This gives Renalware a clean, auditable, and maintainable release model that supports multiple hospitals without reintroducing hospital-specific application forks.

## Examples

### Example branch names

* `main`
* `feature/add-patient-alert-banner`
* `fix/hl7-obr-parser`
* `hotfix/security-header`
* `release/2.5`
* `release/2.7`

### Example Git tags

* `v2.5.0`
* `v2.5.1`
* `v2.5.3`
* `v2.7.0`
* `v2.7.4`

### Example Docker image tags

For a release from commit `1a2b3c4d`:

* `ghcr.io/renalware/renalware:2.5.3`
* `ghcr.io/renalware/renalware:2.5`
* `ghcr.io/renalware/renalware:sha-1a2b3c4d`

For a demo build from `main`:

* `ghcr.io/renalware/renalware:main`
* `ghcr.io/renalware/renalware:main-20260313-0715`
* `ghcr.io/renalware/renalware:sha-1a2b3c4d`

## Example Deployment Matrix

In the renalware-deployment repo we keep track of what versions are deployed where.

```yaml
demo:
  channel: main
  version: 2.8.0-beta.1
  git_sha: abcdef1
  image: ghcr.io/renalware/renalware@sha256:aaa111...

ich:
  channel: release/2.5
  version: 2.5.3
  git_sha: 1234567
  image: ghcr.io/renalware/renalware@sha256:bbb222...

mse:
  channel: release/2.7
  version: 2.7.4
  git_sha: 89abcd0
  image: ghcr.io/renalware/renalware@sha256:ccc333...

blt:
  channel: release/2.7
  version: 2.7.4
  git_sha: 89abcd0
  image: ghcr.io/renalware/renalware@sha256:ccc333...

dvh:
  channel: release/2.7
  version: 2.7.2
  git_sha: 77ee991
  image: ghcr.io/renalware/renalware@sha256:ddd444...
```

## Rules of the Road

1. All new work starts from `main`.
2. Hospitals are pinned to released versions, not to bespoke branches.
3. Fixes are made on `main` first, then backported to supported release branches if needed.
4. Every production deployment must map to a Git tag, Git SHA, and image digest.
5. Docker tags are useful for humans, but deployments should prefer immutable image digests.
6. Hospital-specific behaviour should be implemented through configuration, feature flags, or small isolated conditional code, not long-lived forks.
7. Only a limited number of release lines should be supported at one time.

## Suggested File Location

A good location for this document is:

* `docs/release-strategy.md`

If deployment rules live in a separate infrastructure repository, consider keeping a short copy here in the app repo and a more operational version in the infrastructure repo.
