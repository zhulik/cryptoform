# frozen_string_literal: true

class Cryptoform::Config::StateConfigBuilder
  Config = Data.define(:storage_backend, :encryption_backend)

  STORAGE_BACKENDS = {
    file: Cryptoform::StorageBackends::File
  }.freeze

  ENCRYPTION_BACKENDS = {
    lockbox: Cryptoform::EncryptionBackends::Lockbox
  }.freeze

  def initialize(name, &)
    @name = name

    instance_exec(&)
  end

  def storage_backend(name, **params)
    name = name.to_sym
    raise ArgumentError, "unknown storage backend #{name}" unless STORAGE_BACKENDS.key?(name)

    @storage_backend = STORAGE_BACKENDS[name].new(@name, **params)
  end

  def encryption_backend(name, **params)
    name = name.to_sym
    raise ArgumentError, "unknown encryption backend #{name}" unless ENCRYPTION_BACKENDS.key?(name)

    @encryption_backend = ENCRYPTION_BACKENDS[name].new(@name, **params)
  end

  def config = Config.new(@storage_backend, @encryption_backend)

  def validate!
    if @storage_backend.nil?
      raise Cryptoform::ConfigValidationError, "storage backend must be specified for state '#{@name}'"
    end
    return unless @encryption_backend.nil?

    raise Cryptoform::ConfigValidationError, "encryption backend must be specified for state '#{@name}'"
  end
end
