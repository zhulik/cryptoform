# frozen_string_literal: true

class Cryptoform::EncryptionBackends::Lockbox < Cryptoform::EncryptionBackends::Backend
  def encrypt(object)
    lockbox.encrypt(object.to_json)
  end

  def decrypt(ciphertext)
    JSON.parse(lockbox.decrypt(ciphertext), symbolize_names: true)
  end

  private

  def lockbox
    ::Lockbox.new(key: @params[:key].call, encode: true)
  end
end
