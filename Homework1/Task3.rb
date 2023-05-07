# frozen_string_literal: true
class Triangle
  
  def is_equilateral?

  end

  def is_rectangular?

  end

  def is_isosceles?

  end

end

print "Введите длину стороны 1: "
user_input = gets.chomp
a_side = user_input.to_f
print "Введите длину стороны 2: "
user_input = gets.chomp
b_side = user_input.to_f
print "Введите длину стороны 3: "
user_input = gets.chomp
c_side = user_input.to_f
print "Введите высоту треугольника: "
user_input = gets.chomp
height = user_input.to_f
area = 0.5 * base * height