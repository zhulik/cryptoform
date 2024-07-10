# frozen_string_literal: true

class Cryptoform::Config::StateConfigBuilder
  Config = Data.define(:key, :storage_backend)

  STORAGE_BACKENDS = {
    file: Cryptoform::StorageBackends::File
  }.freeze

  def initialize(name, &)
    @name = name

    instance_exec(&)
  end

  def key(&block) = @key = block

  def storage_backend(name, **)
    name = name.to_sym
    raise ArgumentError, "unknown backend #{name}" unless STORAGE_BACKENDS.key?(name)

    @storage_backend = STORAGE_BACKENDS[name].new(@name, **)
  end

  def config = Config.new(@key, @storage_backend)

  def validate!
    raise Cryptoform::ConfigValidationError, "key must be specified for state '#{@name}'" if @key.nil?
    raise Cryptoform::ConfigValidationError, "backend must be specified for state '#{@name}'" if @storage_backend.nil?
  end
end
