# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def my_attr_accessor(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
        end
      end
    end

    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_history_name = "@#{name}_history".to_sym
        # getters
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}_history") { instance_variable_get(var_history_name) }
        # setter
        define_method("#{name}=".to_sym) do |value|
          history = instance_variable_get(var_history_name) || []
          instance_variable_set(var_history_name, history)
          history << value
          instance_variable_set(var_name, value)
        end
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      var_name = "@#{attr_name}".to_sym
      define_method(attr_name) { instance_variable_get(var_name) }
      define_method("#{attr_name}=".to_sym) do |value|
        raise TypeError, "#{attr_name} is not a #{attr_class} class variable" unless value.is_a? attr_class

        instance_variable_set(var_name, value)
      end
    end
  end

  module InstanceMethods

  end
end


