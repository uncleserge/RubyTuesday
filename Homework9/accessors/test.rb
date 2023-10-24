# frozen_string_literal: true
require_relative 'accessors'

class Test
  include Accessors

  my_attr_accessor :aa, :bb, :cc
  attr_accessor_with_history :my_attr, :a, :b, :c
  strong_attr_accessor :x, Fixnum
  strong_attr_accessor :y, Float
  strong_attr_accessor :z, Test
  strong_attr_accessor :n, Numeric
end

t = Test.new
t.a = 65
t.a = 75
t.a = 85
puts t.a_history

t.b = 65
t.b = 75
t.b = 85
puts t.b_history

t.x = 5
t.y = 10.5

t.n = 10
t.n = 10.56

begin
  t.y = 'abc'
rescue StandardError => e
  puts e.message
end

t.z = t
puts t.inspect

