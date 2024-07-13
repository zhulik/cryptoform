# frozen_string_literal: true

class Cryptoform::StorageBackends::Backend
  def initialize(state_name, **params)
    @state_name = state_name
    @params = params
  end

  def read
    raise NotImplementedError
  end

  def write(data)
    raise NotImplementedError
  end
end
