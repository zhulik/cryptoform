# frozen_string_literal: true

class Cryptoform::Runner
  class ConfigBuilder
    class ConfigValidationError < Cryptoform::Error
    end

    Config = Data.define(:port, :key)

    def initialize
      @port = 3000
    end

    def port(port) = @port = port
    def key(&block) = @key = block

    def validate!
      raise ConfigValidationErrorm, "key must be specified" if @key.nil?
    end

    def config = Config.new(@port, @key)
  end

  class << self
    def run(path)
      config = ConfigBuilder.new.tap { _1.instance_eval(File.read(path)) }
      config.validate!
      Cryptoform::Server.new(config.config).run
    end
  end
end
