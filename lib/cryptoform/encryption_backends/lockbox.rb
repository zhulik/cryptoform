# frozen_string_literal: true

class Cryptoform::EncryptionBackends::Lockbox < Cryptoform::EncryptionBackends::Backend
  def encrypt(json) = lockbox.encrypt(json.to_json)

  def decrypt(ciphertext) = JSON.parse(lockbox.decrypt(ciphertext))

  def lockbox = ::Lockbox.new(key: @params[:key].call, encode: true)
end
