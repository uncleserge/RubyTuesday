# frozen_string_literal: true

module Validation

  TYPES = %i[presence format type].freeze
  def self.included(base)
    base.class_variable_set :@@validates, []
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, type, options = nil)
      raise ArgumentError, "Invalid validation type #{type} for #{attr_name}" unless TYPES.include? type

      vals = class_variable_get :@@validates
      vals << { attr: attr_name, type: type, options: options }
    end

  end

  module InstanceMethods
    def validate!
      vals = self.class.class_variable_get :@@validates
      vals.each do |val|
        # p val[:type]
        value = instance_variable_get "@#{val[:attr]}"
        send "#{val[:type]}_validator".to_sym, value, val[:options]
      end
    end

    def valid?
      validate!
    rescue ArgumentError
      false
    end

    def check_null_or_empty(value)
      # raise ArgumentError, 'Value is null or empty.' if str.nil? || str.empty?
      presence_validator(value)
    end

    def check_null_or_type(value, value_class)
      # raise ArgumentError, 'Station object is null.' if station.nil?
      # raise TypeError, 'Argument is not type of Station.' unless station.is_a?(Station)
      presence_validator(value)
      type_validator(value, value_class)
    end

    private

    def presence_validator(*args)
      value = args.first
      raise ArgumentError, 'The value is null or empty.' if value.nil? || value.is_a?(String) && value.empty?
    end

    def format_validator(value, option)
      raise ArgumentError, "Invalid format for #{value}" unless value.match option
    end

    def type_validator(value, option)
      raise TypeError, "Invalid type for #{value}" unless value.is_a? option
    end
  end
end
