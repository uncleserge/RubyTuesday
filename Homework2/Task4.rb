# frozen_string_literal: true

# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

letters = %w[a e i o u y]
letter_numbers = {}
letters.each { |item| letter_numbers[item] = item.ord - 96 }
puts letter_numbers

