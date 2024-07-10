# frozen_string_literal: true

class Cryptoform::Config::StateConfigBuilder
  Config = Data.define(:key, :backend)

  BACKENDS = {
    file: Cryptoform::Backends::File
  }.freeze

  def initialize(name, &)
    @name = name

    instance_exec(&)
  end

  def key(&block) = @key = block

  def backend(name, **)
    name = name.to_sym
    raise ArgumentError, "unknown backend #{name}" unless BACKENDS.key?(name)

    @backend = BACKENDS[name].new(@name, **)
  end

  def config = Config.new(@key, @backend)

  def validate!
    raise Cryptoform::ConfigValidationError, "key must be specified for state '#{@name}'" if @key.nil?
    raise Cryptoform::ConfigValidationError, "backend must be specified for state '#{@name}'" if @backend.nil?
  end
end
