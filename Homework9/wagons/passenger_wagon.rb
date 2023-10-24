# frozen_string_literal: true

require_relative 'wagon'
require_relative '../modules/validator'

class PassengerWagon < Wagon
  include Validator

  attr_reader :type, :seats, :total_seats

  def initialize(total_seats)
    super()

    @total_seats = total_seats
    validate!
    @seats = 0
    @type = :passenger
  end

  def take_seat
    check_seats
    @seats += 1
  end

  def free_seats
    @total_seats - @seats
  end
end
