# frozen_string_literal: true

require_relative 'wagon'
require_relative '../modules/validator'

class CargoWagon < Wagon
  include Validator

  attr_reader :type, :volume, :total_volume

  def initialize(total_volume)
    super()

    @total_volume = total_volume
    validate!
    @volume = 0
    @type = :cargo
  end

  def fill_volume(value)
    check_volume value
    @volume += value
  end

  def free_volume
    @total_volume - @volume
  end
end
