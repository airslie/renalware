# Shell out to gpg with a a command like this
# gpg --armor --no-default-keyring --keyring keyring.gpg
#     --trust-model always -r 'renalware_test'
#     --output output.xml.enc
#     --encrypt input.xml
#
# Note if you want to see a more verbose output you can add -vv but don't do this here
# as it outputs info to stderr and causes an error to be raised.
#
# Some options may be omitted optional depending on how GPG is set up however as we may use
# more than 1 GPG key on thie server, we are explicitly setting the
# Recipient may be optional e.g. --recipient 'patient view'
class GpgEncryptFolder
  pattr_initialize [:folder!, :options!]

  def call
    Dir.glob(folder.join("*.xml")) do |file|
      GpgEncryptFile.new(file: file, options: options).call
    end
  end
end

class GpgOptions
  attr_reader_initialize [
    :recipient,
    :destination_folder,
    :public_key_name
  ]
end

class GpgEncryptFile
  pattr_initialize [:file!, :options!]

  def call
    err = Open3.popen3(gpg_command) do |_stdin, _stdout, stderr|
      stderr.read
    end
    raise "Error encrypting UKRDC files: #{err}, #{gpg_command}" unless err.empty?
  end

  private

  def gpg_command
    @gpg_command ||= GpgCommand.new(file: file, options: options).to_s
  end
end

class GpgCommand
  attr_reader :file, :options

  delegate :public_key_name, :recipient, to: :options

  def initialize(file:, options:)
    @file = file
    @options = options
    create_keyring unless keyring_path.exist?
  end

  # Note we skip using a random seed file (normally created at var/ukrdc/gpgkey/random_seed)
  # because we had problems at KCH where the file would become corrupt, breaking the export, and
  # fixable only by deleting the random_seed file and letting gpg re-create one.
  # Using the --no-random-seed-file option the file is not used so we avoid that problem.
  def to_s
    [
      "gpg",
      "--armor",
      "--no-default-keyring",
      "--trust-model always",
      "--no-random-seed-file",
      "--keyring \"#{keyring_path}\"",
      "--recipient \"#{recipient}\"",
      "-o \"#{encrypted_filename}\" " \
      "--encrypt \"#{file}\""
    ].join(" ")
  end

  def filename_without_extension
    File.basename(file, ".xml")
  end

  def output_filename
    "#{filename_without_extension}.gpg"
  end

  def encrypted_filename
    options.destination_folder.join(output_filename)
  end

  def create_keyring
    `gpg --import --no-default-keyring --keyring #{keyring_path} #{public_key_path}`
  end

  def public_key_path
    gpg_config_folder.join("public_keys", public_key_name)
  end

  def keyring_path
    gpg_config_folder.join("ukrdc_keyring.gpg")
  end

  def gpg_config_folder
    Renalware::Engine.root.join("config/gpg")
  end
end
