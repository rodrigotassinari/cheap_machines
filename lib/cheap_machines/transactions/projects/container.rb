module CheapMachines
  module Transactions
    module Projects
      class Container
        extend Dry::Container::Mixin

        namespace :key_pair do
          register(:check) { CheapMachines::Operations::KeyPair::Check.new }
          register(:tag) { CheapMachines::Operations::KeyPair::Tag.new }
        end

      end
    end
  end
end
