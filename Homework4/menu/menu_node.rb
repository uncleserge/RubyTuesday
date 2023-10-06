# frozen_string_literal: true

class MenuNode
  attr_reader :name, :method
  attr_accessor :parent

  def initialize(name, method = nil)
    @name = name
    @method = method
    @parent = parent
    @nodes = []
  end

  def add_child(node)
    raise StandardError, "Menu with name #{node.name} already exists!" if name_exists? node.name

    node.parent = self
    @nodes.push node
    node
  end

  def del_child(name)
    index = @nodes.find_index { |element| element.name = name}
    @nodes.delete_at(index) unless index.nil?
  end

  def nodes
    Array.new(@nodes)
  end

  def children?
    @nodes.length.positive?
  end

  private

  def name_exists?(name)
    @nodes.find_index { |element| element.name == name }
  end
end
