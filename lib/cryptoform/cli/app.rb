# frozen_string_literal: true

class Cryptoform::CLI::App < Thor
  class << self
    def exit_on_failure?
      false
    end
  end

  default_command :server

  no_commands do
    def cryptofile_path
      options[:cryptofile]
    end

    def read_cryptofile
      File.read(cryptofile_path)
    end
  end
end
