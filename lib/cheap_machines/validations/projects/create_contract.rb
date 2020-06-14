module CheapMachines
  module Validations
    module Projects
      class CreateContract < Dry::Validation::Contract
        schema do
          required(:project_name).filled(:string)
          required(:key_pair_name).filled(:string)
          required(:public_ip).value(format?: /\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b/)
          required(:ec2_client).value(type?: ::Aws::EC2::Client)
          required(:logger)
        end

        rule(:project_name) do
          key.failure('must be less than 256 characters') if value.size > 255
          key.failure('must be comprised of letters, numbers, spaces and the following characters: + - = . _ : / @') if !value.match?(/\A[\w\s\+\-\=\.\:\/\@]+\z/)
        end

        rule(:logger) do
          key.failure('must quack like a Logger') if !value.kind_of?(::Logger)
        end
      end
    end
  end
end
