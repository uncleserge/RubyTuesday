# frozen_string_literal: true

# Квадратное уравнение. Пользователь вводит 3 коэффициента a, b и с.
# Программа вычисляет дискриминант (D) и корни уравнения (x1 и x2, если они есть) и
# выводит значения дискриминанта и корней на экран. При этом возможны следующие варианты:
#   Если D > 0, то выводим дискриминант и 2 корня
#   Если D = 0, то выводим дискриминант и 1 корень (т.к. корни в этом случае равны)
#   Если D < 0, то выводим дискриминант и сообщение "Корней нет"

class Quadratic_equation
  attr_accessor :coef_a, :coef_b, :coef_c  # коэффициенты

  def initialize(a, b, c)
    @coef_a = a
    @coef_b = b
    @coef_c = c
  end

  def discriminant
    @coef_b**2 - 4 * @coef_a * @coef_c
  end
  def roots
    denom = 2 * @coef_a
    discrim = self.discriminant

    if discrim > 0
      [(-@coef_b + Math.sqrt(discrim))/denom, (-@coef_b - Math.sqrt(discrim))/denom]
    elsif discriminant == 0
      -@coef_b / denom
    else
      nil
    end
  end
end

def get_number (msg, err_msg)
  begin
    print msg
    result = Float(gets)
  rescue
    puts err_msg
    retry
  end

  result
end

coef_a= get_number("Введите коэффициент 'a': ", "Ошибка! Введите число.")
coef_b = get_number("Введите коэффициент 'b': ", "Ошибка! Введите число.")
coef_c = get_number("Введите коэффициент 'c': ", "Ошибка! Введите число.")

equation = Quadratic_equation.new(coef_a, coef_b, coef_c)

puts "Уравнение: #{coef_a} x^2 + #{coef_b} x + c = 0"
puts "Дискриминант: #{equation.discriminant}"
if equation.discriminant > 0
  puts "Корни уравнения: #{equation.roots}"
elsif equation.discriminant == 0
  puts "Корень уравнения: #{equation.roots}"
else
  puts "Корней нет."
end


