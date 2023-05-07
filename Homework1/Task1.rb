# Идеальный вес.
#   Программа запрашивает у пользователя имя и рост и
#   выводит идеальный вес по формуле (<рост> - 110) * 1.15,
#   после чего выводит результат пользователю на экран с обращением по имени.
#   Если идеальный вес получается отрицательным,
#   то выводится строка "Ваш вес уже оптимальный"

print "Введите ваше имя: "
name = gets.chomp

height = 0
while height == 0
  print "Введите ваш рост в см.: "
  user_input= gets.chomp
  height = user_input.to_f
  if height == 0
    puts "Ошибка! Введите число, отличное от 0."
  end
end
# print "Введите ваш рост: "
# user_input= gets.chomp
# height = user_input.to_f
# begin
#   height = user_input.to_f
# rescue
#   puts "Ошибка! Значение должно быть числом."
# end
# puts height.to_i
# puts height.is_a?(Integer)
# while !height.is_a?(Integer)
#   print "Введите целое число: "
#   height = gets.chomp
# end
# height = height.to_i

# puts name
# puts height

result = (height - 110) * 1.15
puts "#{name}, ваш результат - #{result}"
puts "Ваш вес уже оптимальный" if result < 0
