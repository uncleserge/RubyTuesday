# frozen_string_literal: true

class UI
  def self.get_str(msg, err_msg)
    begin
      print msg
      result = gets.chomp.strip
      raise StandardError, err_msg if result.empty?
    rescue StandardError => e
      puts e.message
      retry
    end
    result
  end

  def self.get_num(msg, err_msg, max)
    begin
      print msg
      result = Integer(gets.chomp)
      raise ArgumentError if result.negative? || result > max
    rescue TypeError, ArgumentError
      puts err_msg
      retry
    end
    result
  end
end
