# frozen_string_literal: true

class Cryptoform::EncryptionBackends::Lockbox < Cryptoform::EncryptionBackends::Backend
  def encrypt(text) = lockbox.encrypt(text)

  def decrypt(ciphertext) = lockbox.decrypt(ciphertext)

  def lockbox = ::Lockbox.new(key: @params[:key].call, encode: true)
end
