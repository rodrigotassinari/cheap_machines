module CheapMachines
  module Operations
    module Projects
      class Create
        include Dry::Transaction
        # check key pair exists
        #   error if informed key pair does not exist
        #   tag existing key pair with tag:ProjectName with project name (if needed)
        # check VPC exists with tag:ProjectName
        #   create VPC with tag:ProjectName if needed
        # check subnet exists with tag:ProjectName (in project VPC)
        #   create subnet if needed
        # check SG exists with tag:ProjectName (in project VPC)
        #   create SG if needed
        # check SG minimum access rules (SSH & MOSH from public ip) (if supplied public_ip)
        #   create SG minimum access rules if needed (if supplied public_ip)
        # return created project data: name, key pair info, SG info, VPC info, subnet info
        

        private

      end
    end
  end
end
