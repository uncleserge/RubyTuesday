# frozen_string_literal: true
class Triangle
  attr_reader :sides
  def initialize(side_1, side_2, side_3)
    @sides = [side_1, side_2, side_3]
  end

  def side_1=(side_1) #setter method
    @sides[0] = side_1
  end
  def side_1
    @sides[0]
  end
  def side_2=(side_2) #setter method
    @sides[1] = side_2
  end
  def side_2
    @sides[1]
  end
  def side_3=(side_3) #setter method
    @sides[2] = side_3
  end
  def side_3
    @sides[2]
  end

  def is_equilateral? # равносторонний ?
    true if @sides.uniq.size == 1
  end

  def is_rectangular? # прямоугольный ?
    sides = Array.new(@sides)
    max_side = sides.max
    index_of_max = sides.index(max_side)
    sides.delete_at(index_of_max)**2 == sides[0]**2 + sides[1]**2
  end

  def is_isosceles? # равнобедренный ?
    true if @sides.uniq.size <= 2
  end

end

def get_number (msg, err_msg)
  begin
    print msg
    result = Float(gets)
    raise if result < 0
  rescue
    puts err_msg
    retry
  end

  result
end

side_1 = get_number("Введите длину стороны 1: ", "Ошибка! Введите число больше 0.")
side_2 = get_number("Введите длину стороны 2: ", "Ошибка! Введите число больше 0.")
side_3 = get_number("Введите длину стороны 3: ", "Ошибка! Введите число больше 0.")
triangle = Triangle.new(side_1, side_2, side_3)

puts "Стороны треугольника: #{triangle.sides}"
puts "треугольник является прямоугольным" if triangle.is_rectangular?
puts "треугольник является равнобедренным" if triangle.is_isosceles?
puts "треугольник является равносторонним" if triangle.is_equilateral?