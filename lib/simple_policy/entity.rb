# frozen_string_literal: true

module SimplePolicy
  class Entity
    include Callee

    param :object
    param :options, default: proc { {} }
    param :block, optional: true

    def self.object_alias(name)
      define_method(name) do
        object
      end
    end

    def self.applies_to_all?(collection, options = {}, &block)
      collection.all? do |object|
        applies_to?(object, options, &block)
      end
    end

    def self.applies_to_any?(collection, options = {}, &block)
      collection.any? do |object|
        applies_to?(object, options, &block)
      end
    end

    def self.applies_to?(object, options = {}, &block)
      call(object, options, block)
    end
  end
end
