module CheapMachines
  module Transactions
    module Projects
      class Create
        CONTAINER = CheapMachines::Container
        include Dry::Transaction(container: CONTAINER)

        step :validate_input
        step :check_key_pair, with: 'operations.key_pairs.check'
        step :tag_key_pair, with: 'operations.key_pairs.tag'

        # check VPC exists with tag:ProjectName
        # step :check_vpc, with: 'vpc.check'
        #   create VPC with tag:ProjectName if needed
        # step :create_vpc, with: 'vpc.create'
        # step :find_or_create_vpc, with: 'vpc.find_or_create'

        # check subnet exists with tag:ProjectName (in project VPC)
        # step :check_subnet, with: 'subnet.check'
        #   create subnet if needed
        # step :create_subnet, with: 'subnet.create'
        # step :find_or_create_subnet, with: 'subnet.find_or_create'

        # check SG exists with tag:ProjectName (in project VPC)
        #   create SG if needed

        # check SG minimum access rules (SSH & MOSH from public ip) (if supplied public_ip)
        #   create SG minimum access rules if needed (if supplied public_ip)

        # return created project data: name, key pair info, SG info, VPC info, subnet info

        private

        def validate_input(input, validator: 'validations.projects.create')
          result = CONTAINER.resolve(validator).call(input)
          result.success? ? Success(input) : Failure(result.errors.to_h)
        end

        def find_or_create_vpc(input, find_operation: 'operations.vpc.get', create_operation: 'operations.vpc.create')
          find_result = CONTAINER.resolve(find_operation).call(input)
          return Success(find_result.success) if find_result.success?
          
          create_result = CONTAINER.resolve(create_operation).call(input)
          create_result.success? ? Success(create_result.success) : Failure(create_result.failure)
        end

      end
    end
  end
end
