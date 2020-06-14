module CheapMachines
  class Container
    extend Dry::Container::Mixin

    namespace :operations do
      namespace :key_pairs do
        register(:check) { Operations::KeyPair::Check.new }
        register(:tag) { Operations::KeyPair::Tag.new }
      end
    end

    namespace :validations do
      namespace :projects do
        register(:create) { Validations::Projects::CreateContract.new }
      end
    end

  end
end
