# frozen_string_literal: true

class Cryptoform::StorageBackends::File < Cryptoform::StorageBackends::Backend
  def read
    ::File.read(filename)
  rescue Errno::ENOENT
    raise Cryptoform::StateMissingError, "state '#{@state_name}' is configured but missing"
  end

  def write(data) = ::File.write(filename, data)

  private

  def filename = @filename ||= @params[:name] || "#{@state_name}.tfstate.enc"
end
