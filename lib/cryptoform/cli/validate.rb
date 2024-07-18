# frozen_string_literal: true

class Cryptoform::CLI::Validate < Cryptoform::CLI::Command
  thor do
    desc "validate", "validate your cryptofile"
    option :cryptofile, type: :string, default: Cryptoform::CRYPTOFILE

    def validate
      Cryptoform.load_cryptofile!(read_cryptofile)
      puts "#{cryptofile_path} is valid!"
    rescue Cryptoform::ConfigValidationError => e
      puts "#{cryptofile_path} is invalid:"
      puts(e.message)
    end
  end
end
