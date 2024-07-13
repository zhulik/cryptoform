# frozen_string_literal: true

class Cryptoform::EncryptionBackends::Lockbox < Cryptoform::EncryptionBackends::Backend
  def encrypt(json)
    lockbox.encrypt(json.to_json)
  end

  def decrypt(ciphertext)
    JSON.parse(lockbox.decrypt(ciphertext))
  end

  def lockbox
    ::Lockbox.new(key: @params[:key].call, encode: true)
  end
end
