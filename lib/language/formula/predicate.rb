require_relative '../formula.rb'

class Predicate < Formula
  attr_reader :name, :terms
  include Expression

  def initialize(name, terms)
    @name = name
    @terms = terms
  end

  def free_variables
    @terms.map(&:free_variables).flatten.uniq
  end

  def free_unification_terms
    @terms.map(&:free_unification_terms).flatten.uniq
  end

  def replace(old, new)
    return new if eql?(old)
    Predicate.new(@name, @terms.map { |term| term.replace(old, new) })
  end

  def set_instantiation_time(time)
    @terms.each{ |term| term.set_instantiation_time(time) }
  end

  def occurs(unification_term)
    @terms.any? { |term| term.occurs(unification_term) }
  end

  def to_s
    "#{@name}(#{terms.join(', ')})"
  end

  def eql?(exp)
    return false unless exp.is_a?(Predicate)
    return false unless @name == exp.name
    return false unless @terms.length == exp.terms.length
    @terms.zip(exp.terms).all? { |t1, t2| t1.eql?(t2) }
  end

end
