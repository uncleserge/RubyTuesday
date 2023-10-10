# frozen_string_literal: true

module Validator
  def self.included(base)
    base.include StationInstanceMethods if base.name.to_sym == :Station
    base.include TrainInstanceMethods if base.name.to_sym == :Train
    base.include RouteInstanceMethods if base.name.to_sym == :Route
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  module StationInstanceMethods

    protected

    def validate!
      title = instance_variable_get(:@title)
      check_null_or_empty! title
    end

    def check_null_or_empty!(str)
      raise ArgumentError, 'Station title is null or empty.' if str.nil? || str.empty?
    end

    def check_null_or_train(train)
      raise ArgumentError, 'Train object is null.' if train.nil?
      raise TypeError, 'Argument is not type of Train.' unless train.is_a?(Train)
    end
  end

  module RouteInstanceMethods

    protected

    def validate!
      first = instance_variable_get(:@stations)&.first
      raise ArgumentError, 'Station object is null.' if first.nil?
      raise TypeError, 'Argument is not type of Station.' unless first.is_a?(Station)

      last = instance_variable_get(:@stations)&.last
      raise ArgumentError, 'Station object is null.' if last.nil?
      raise TypeError, 'Argument is not type of Station.' unless last.is_a?(Station)
    end

    def check_null_or_station(station)
      raise ArgumentError, 'Station object is null.' if station.nil?
      raise TypeError, 'Argument is not type of Station.' unless station.is_a?(Station)
    end
  end
  
  module TrainInstanceMethods

    protected

    NUM_TEMPLATE = /[a-z\d]{3}-?[a-z\d]{2}/i.freeze
    def validate!
      num = instance_variable_get(:@number)
      #puts("number: #{num}")
      raise ArgumentError, 'Train number is null or empty.' if num.nil? || num.empty?
      raise StandardError, 'Non valid number format' unless num.match NUM_TEMPLATE
    end

    def check_null_or_route(route)
      raise ArgumentError, 'Route object is null.' if route.nil?
      raise TypeError, 'Argument is not type of Route.' unless route.is_a?(Route)
    end
  end

end
