# frozen_string_literal: true

class Cryptoform::EncryptionBackends::Backend
  def initialize(state_name, **params)
    @state_name = state_name
    @params = params
  end

  def decrypt(ciphertext)
    raise NotImplementedError
  end

  def encrypt(json)
    raise NotImplementedError
  end
end
