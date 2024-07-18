# frozen_string_literal: true

class Cryptoform::CLI::Cat < Cryptoform::CLI::Command
  thor do
    desc "cat <state name>", "prints decytpted state"

    option :cryptofile, type: :string, default: Cryptoform::CRYPTOFILE

    def cat(name)
      config = Cryptoform::Config::Builder.new(read_cryptofile).config
      state_config = config.states[name.to_sym]

      state = state_config.encryption_backend.decrypt(state_config.storage_backend.read)
      puts(JSON.pretty_generate(state))
    rescue Cryptoform::Error => e
      puts(e.message)
      exit(1)
    end
  end
end
