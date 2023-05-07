# frozen_string_literal: true
#
# Площадь треугольника. Площадь треугольника можно вычислить,
# зная его основание (a) и высоту (h) по формуле: 1/2*a*h.
# Программа должна запрашивать основание и высоту треугольника и возвращать его площадь.

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

base = get_number("Введите основание треугольника: ", "Ошибка! Введите положительное число.")
height = get_number("Введите высоту треугольника: ", "Ошибка! Введите положительное число.")

area = 0.5 * base * height
puts "Площадь тругольника равна #{area}"
