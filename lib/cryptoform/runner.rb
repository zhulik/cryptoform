# frozen_string_literal: true

class Cryptoform::Runner
  class << self
    def run(path)
      config = Cryptoform::Config::Builder.new.tap { _1.instance_eval(File.read(path)) }
      config.validate!
      Cryptoform::Server.new(config.config).run
    end
  end
end
