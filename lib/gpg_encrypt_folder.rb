# frozen_string_literal: true

require "attr_extras"

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
    Dir.glob(folder.join("xml", "*.xml")) do |file|
      GpgEncryptFile.new(file: file, options: options).call
    end
  end
end

class GpgOptions
  attr_reader_initialize [:recipient, :keyring, :homedir, :filename_transform]
end

class GpgEncryptFile
  pattr_initialize [:file!, :options!]

  def call
    err = Open3.popen3(gpg_command) do |_stdin, _stdout, stderr|
      stderr.read
    end
    raise "Error encrypting UKRDC files: #{err}" unless err.empty?
  end

  private

  def gpg_command
    GpgCommand.new(file: file, options: options).to_s
  end
end

class GpgCommand
  pattr_initialize [:file!, :options!]

  def to_s
    "gpg --armor --no-default-keyring --trust-model always "\
      "#{keyring} #{homedir} #{recipient} "\
      "-o #{encrypted_filename} "\
      "--encrypt #{file}"
  end

  def recipient
    options.recipient && "--recipient #{options.recipient}"
  end

  def homedir
    options.homedir && "--homedir #{options.homedir}"
  end

  def keyring
    "--keyring #{options.keyring}"
  end

  # Calls a proc to transform the in file name into an out file name
  def encrypted_filename
    options.filename_transform.call(file)
  end
end
