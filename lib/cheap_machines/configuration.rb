module CheapMachines
  class Configuration
    attr_accessor :access_key_id, :secret_access_key

    def initialize(values={})
      @access_key_id = values[:access_key_id]
      @secret_access_key = values[:secret_access_key]
    end
  end
end
