# frozen_string_literal: true

class Cryptoform::CLI::Server < Cryptoform::CLI::Command
  thor do
    desc "server", "run cryptoform server"
    option :cryptofile, type: :string, default: Cryptoform::CRYPTOFILE

    def server
      Cryptoform.run!(File.read(cryptofile_path))
    end
  end
end