# frozen_string_literal: true

# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
#
# Как определить, является ли год високосным
#
# Чтобы определить, является ли год високосным, выполните следующие действия:
#
#     Если год делится на 4 без остатка, перейдите на шаг 2. В противном случае перейдите к выполнению действия 5.
#     Если год делится на 100 без остатка, перейдите на шаг 3. В противном случае перейдите к выполнению действия 4.
#     Если год делится на 400 без остатка, перейдите на шаг 4. В противном случае перейдите к выполнению действия 5.
#     Год високосный (366 дней).
#     Год не високосный год (365 дней).

class Gregorian_date
  MONTHS = { January: 31, February: 28, March: 31, April: 30, May: 31, June: 30,
             July: 31, August: 31, September: 30, October: 31, November: 30, December: 31}
  def initialize(y, m, d)
    raise RangeError if y < 1582
    @year = y
    raise RangeError if m < 1 || m > 12
    @month = m
    max_day_number = is_leap_year? && @month == 2 ? MONTHS.values[@month-1]+1 : MONTHS.values[@month-1]
    raise RangeError if d < 1 || d > max_day_number
    @day = d
  end
  def is_leap_year? # високосный год ?
    (@year % 4 == 0) && !(@year % 100 == 0) || (@year % 400 == 0)
  end
  def day_number_in_year # порядковый номер дня в годуTask6
    result = MONTHS.values.take(@month-1).sum + @day
    result += 1 if is_leap_year? && @month > 2
    result
  end
  def date
    "Year: #{@year}, Month: #{MONTHS.keys[@month-1]}, Day: #{@day}"
  end
end

def get_number (msg, err_msg) # user input function
  begin
    print msg
    result = Integer(gets)
  rescue
    puts err_msg
    retry
  end

  result
end

begin
  year = get_number("Введите год: ", "Ошибка! Введите число от 1582.")
  month = get_number("Введите месяц: ", "Ошибка! Введите число от 1 до 12.")
  day = get_number("Введите день: ", "Ошибка! Введите число от 1 до 31.")
  my_date = Gregorian_date.new(year, month, day)
rescue
  puts "Ошибка! Вы ввели неверную дату."
  retry
end

puts "Вы ввели дату: #{my_date.date}"
puts "Порядковый номер даты, начиная с начала года: #{my_date.day_number_in_year}"
