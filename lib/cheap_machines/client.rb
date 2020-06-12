module CheapMachines
  class Client

    attr_reader :access_key_id, :secret_access_key, :region, :logger

    def initialize(access_key_id:, secret_access_key:, region:, logger: nil)
      @access_key_id = access_key_id
      @secret_access_key = secret_access_key
      @region = region
      @logger = logger || default_logger
    end

    def create_project(project_name:, key_pair_name:, public_ip:)
      result = Operations::Projects::Create.new.call(
        client: self,
        project_name: project_name,
        key_pair_name: key_pair_name,
        public_ip: public_ip
      )
      result.success?
    end

    def show_project(project_name:)
    end

    def destroy_project(project_name:)
    end

    def list_machines(project_name:)
    end

    def create_machine(name:, project_name:, instance_type:, volume_size:, user_data:)
    end

    def destroy_machine(name:, project_name:)
    end

    def show_machine(name:, project_name:)
    end

    def start_machine(name:, project_name:)
    end

    def pause_machine(name:, project_name:)
    end

    def resume_machine(name:, project_name:)
    end

    def stop_machine(name:, project_name:)
    end

    def resize_machine(name:, project_name:, new_instance_type:)
    end

    def create_access_rule(project_name:, cidr:, from_port:, to_port:)
    end

    private

    def default_logger
      ::Logger.new(STDOUT, level: ::Logger::INFO)
    end

  end
end
