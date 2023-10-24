# frozen_string_literal: true

require_relative '../modules/manufacturer'

class Wagon
  include Manufacturer
  attr_reader :id

  def initialize
    @id = Random.rand.to_s[2, 10]
  end
end
