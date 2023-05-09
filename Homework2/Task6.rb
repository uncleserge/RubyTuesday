# frozen_string_literal: true

# Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу и
# кол-во купленного товара (может быть нецелым числом).
# Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп"
# в качестве названия товара. На основе введенных данных требуетеся:
#
#   -  Заполнить и вывести на экран хеш, ключами которого являются названия товаров,
#      а значением - вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара.
#      Также вывести итоговую сумму за каждый товар.
#   -  Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".

class Basket
  def initialize
    @items = {}
  end

  def add_item(title, price, quantity)
    @items[title.to_sym] = {price: price, quantity: quantity}
  end

  def get_item_sum(title)
    item = @items[title.to_sym]
    item[:price]*item[:quantity]
  end

  def total
    @items.values.sum(0) {|el| el[:price]*el[:quantity]}
  end

  def print
    @items.each do |title, item|
      puts "#{title.to_s}:   #{item[:price]}   x #{item[:quantity]}   = #{self.get_item_sum(title)}"
    end
    puts "Итого: #{self.total}"
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

basket=Basket.new

loop do
  print "Введите название товара: "
  title = gets.chomp
  break if %w[stop стоп].include? title

  price = get_number("Введите цену за единицу:", "Ошибка! Введите число.")
  quantity = get_number("Введите количество:", "Ошибка! Введите число.")

  basket.add_item(title,price,quantity)
end

basket.print
