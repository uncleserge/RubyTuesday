# frozen_string_literal: true
require_relative 'wagon'
class CargoWagon < Wagon
  attr_reader :type

  def initialize
    super
    @type = :cargo
  end
end
