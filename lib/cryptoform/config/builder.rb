# frozen_string_literal: true

class Cryptoform::Config::Builder
  Config = Data.define(:port, :states)

  def initialize
    @port = 3000
    @states = {}
  end

  def port(port) = @port = port

  def state(name, &)
    name = name.to_sym

    raise ArgumentError, "state #{name} already configured" if @states.key?(name)

    @states[name] = Cryptoform::Config::StateConfigBuilder.new(name, &)
  end

  def validate!
    @states.each_value(&:validate!)

    raise Cryptoform::ConfigValidationError, "port must be an integer" if @key.is_a?(Numeric)
  end

  def config = Config.new(@port, @states.transform_values(&:config))
end
