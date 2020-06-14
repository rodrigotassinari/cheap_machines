module CheapMachines
  module Operations
    module KeyPair
      class Check
        include Dry::Transaction::Operation
        
        # Checks if the given key_pair exists in AWS.
        #
        # @param input [Hash] the input (only relevant keys documented below)
        # @option input [Aws::EC2::Client] :ec2_client The configured AWS EC2 client
        # @option input [Logger] :logger The logger
        # @option input [String] :key_pair_name The logger
        # @return [Dry::Monads::Success] A success object with the similar input as output if the key pair is found
        #   (on key_pair_name is removed, key_pair is added)
        # @return [Dry::Monads::Failure] A failure object with a error message string if no matching key pair is found
        def call(input)
          ec2 = input[:ec2_client]
          logger = input[:logger]
          key_name = input.delete(:key_pair_name)

          key_pair = find_key_pair(ec2, key_name)
          return Failure("no key pair found with name: '#{key_name}'") if key_pair.nil?
          Success(input.merge(key_pair: key_pair))
        rescue Aws::Errors::ServiceError, Aws::Errors::NoSuchEndpointError => exception
          Failure("error connecting to AWS: #{exception.inspect}")
        end

        private

        def find_key_pair(ec2, key_name)
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Client.html#describe_key_pairs-instance_method
          response = ec2.describe_key_pairs(
            filters: [
              {name: "key-name", values: [key_name]}
            ]
          )
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Types/KeyPairInfo.html
          response.key_pairs.detect { |kpi| kpi[:key_name] == key_name }
        end

      end
    end
  end
end
