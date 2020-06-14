module CheapMachines
  class Client

    attr_reader :logger

    def initialize(access_key_id:, secret_access_key:, region:, logger: nil)
      @logger = logger || default_logger
      @access_key_id = access_key_id
      @secret_access_key = secret_access_key
      @region = region
    end

    def ec2_client
      @ec2_client ||= ::Aws::EC2::Client.new(
        region: @region,
        credentials: ::Aws::Credentials.new(@access_key_id, @secret_access_key),
        logger: self.logger,
        # see https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/timeout-duration.html
        retry_limit: 3,
        retry_backoff: lambda { |c| sleep(15) }
      )
    end

    def create_project(project_name:, key_pair_name:, public_ip:)
      transaction = Transactions::Projects::Create.new
      input = {
        ec2_client: self.ec2_client,
        logger: self.logger,
        project_name: project_name,
        key_pair_name: key_pair_name,
        public_ip: public_ip
      }
      execute(transaction, input) do |m|
        m.success do |output| # output will be what? hash with project data?
          self.logger.info("Project Created: #{output.inspect}")
          true
        end

        m.failure(:validate) do |validation|
          # Runs only when the transaction fails on the :validate step
          puts "Please provide a valid user."
        end

        m.failure do |error|
          # Runs for any other failure
          self.logger.error("Could not create the project: #{error.inspect}")
          false
        end
      end 
    end

    # def show_project(project_name:)
    # end

    # def destroy_project(project_name:)
    # end

    # def list_machines(project_name:)
    # end

    # def create_machine(name:, project_name:, instance_type:, volume_size:, user_data:)
    # end

    # def destroy_machine(name:, project_name:)
    # end

    # def show_machine(name:, project_name:)
    # end

    # def start_machine(name:, project_name:)
    # end

    # def pause_machine(name:, project_name:)
    # end

    # def resume_machine(name:, project_name:)
    # end

    # def stop_machine(name:, project_name:)
    # end

    # def resize_machine(name:, project_name:, new_instance_type:)
    # end

    # def create_access_rule(project_name:, cidr:, from_port:, to_port:)
    # end

    private

    def default_logger
      ::Logger.new(STDOUT, level: ::Logger::INFO)
    end

    def match(result, &block)
      ::Dry::Matcher::ResultMatcher.(result, &block)
    end

    def execute(transaction, input, &block)
      match(transaction.call(input), &block)
    end

  end
end
