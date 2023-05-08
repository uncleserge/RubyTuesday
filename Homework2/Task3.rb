# frozen_string_literal: true

# Заполнить массив числами фибоначчи до 100

fibonacci_seq = [0, 1]

while (new_number = fibonacci_seq.last(2).sum) <= 100
  fibonacci_seq << new_number
end
puts fibonacci_seq
