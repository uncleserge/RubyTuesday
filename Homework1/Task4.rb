# frozen_string_literal: true

class Equation
  attr_accessor :a, :b, :c  # коэффициенты

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def discriminant
    (b**2)-(4*a*c)
  end
  def roots
    if discriminant > 0
      denominator = 2*a
      [(-b+c)/denominator, (-b-c)/denominator]
    else
      nil
    end
  end
end

equation = Equation.new(3, 9, 3)
puts equation.roots
