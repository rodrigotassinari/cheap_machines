module CheapMachines
  module Operations
    module KeyPair
      class Tag
        include Dry::Transaction::Operation

        # Adds a project tag to the key_pair, if needed
        #
        # @param input [Hash] the input (only relevant keys documented below)
        # @option input [Aws::EC2::Client] :ec2_client The configured AWS EC2 client
        # @option input [Logger] :logger The logger
        # @option input [Aws::EC2::Types::KeyPairInfo] :key_pair The key_pair
        # @option input [String] :project_name The project name
        # @return [Dry::Monads::Success] A success object with the same input as output
        # @return [Dry::Monads::Failure] A failure object with a error message string if the operation failed
        def call(input)
          ec2 = input[:ec2_client]
          logger = input[:logger]
          project_name = input[:project_name]
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Types/KeyPairInfo.html
          key_pair = input[:key_pair]

          unless has_project_tag?(key_pair, project_name)
            add_project_tag(ec2, key_pair, project_name)
          end

          Success(input)
        rescue Aws::Errors::ServiceError, Aws::Errors::NoSuchEndpointError => exception
          Failure("error connecting to AWS: #{exception.inspect}")
        end

        private

        def has_project_tag?(key_pair, project_name)
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Types/Tag.html
          key_pair.tags.detect { |t| t.key == "ProjectName" }&.value == project_name
        end

        def add_project_tag(ec2, key_pair, project_name)
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EC2/Client.html#create_tags-instance_method
          ec2.create_tags(
            resources: [key_pair.key_pair_id],
            tags: [{key: "ProjectName", value: project_name}]
          )
        end

      end
    end
  end
end
