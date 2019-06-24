require_relative 'expression.rb'
class Term
  attr_reader :time, :name
  TIME_DEFAULT = 0
  include Expression
  def initialize(name)
    @name = name
    @time = TIME_DEFAULT
  end
end
