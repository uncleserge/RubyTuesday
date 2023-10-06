# frozen_string_literal: true

class Wagon
  attr_reader :id

  def initialize
    @id = Random.rand.to_s[2, 10]
  end
end
