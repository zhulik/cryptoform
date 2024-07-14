# frozen_string_literal: true

class Cryptoform::EncryptionBackends::DiffLockbox < Cryptoform::EncryptionBackends::Lockbox
  def encrypt(json)
    JSON.pretty_generate(encrypt_object(json, lockbox))
  end

  def decrypt(ciphertext)
    decrypt_object(JSON.parse(ciphertext, symbolize_names: true), lockbox)
  end

  private

  def decrypt_object(object, box)
    return object.transform_values { decrypt_object(_1, box) } if object.is_a?(Hash)
    return object.map { decrypt_object(_1, box) } if object.is_a?(Array)

    decrypted = box.decrypt(object)

    decrypted.start_with?("{") ? JSON.parse(decrypted, symbolize_names: true)[:value] : decrypted
  end

  def encrypt_object(object, box)
    return object.transform_values { encrypt_object(_1, box) } if object.is_a?(Hash)
    return object.map { encrypt_object(_1, box) } if object.is_a?(Array)

    box.encrypt({ value: object }.to_json)
  end
end
