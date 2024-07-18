# frozen_string_literal: true

class Cryptoform::Config::Builder
  PORTS = 1..65_535
  Config = Data.define(:port, :states)

  def initialize(cryptofile)
    @port = 3000
    @states = {}

    instance_eval(cryptofile)
    validate!
  end

  def port(port)
    @port = port
  end

  def state(name, &)
    name = name.to_sym

    raise ArgumentError, "state #{name} already configured" if @states.key?(name)

    @states[name] = Cryptoform::Config::StateConfigBuilder.new(name, &)
  end

  def validate!
    @states.each_value(&:validate!)
    raise Cryptoform::ConfigValidationError, "at least one state must be configured" if @states.empty?
    raise Cryptoform::ConfigValidationError, "port must be an in range 0-65545" unless PORTS.include?(@port)
  end

  def config
    Config.new(@port, @states.transform_values(&:config))
  end
end
