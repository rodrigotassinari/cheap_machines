module CheapMachines
  module Operations
    module KeyPair
      class Check
        include Dry::Transaction::Operation

        def call(input)
          # returns Success(valid_data) or Failure(validation)
          Success(input) # TODO
        end

      end
    end
  end
end