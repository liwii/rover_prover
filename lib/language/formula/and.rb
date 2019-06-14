require_relative '../formula.rb'

class And < Formula
  attr_reader :formula_a, :formula_b

  def initialize(formula_a, formula_b)
    @formula_a = formula_a
    @formula_b = formula_b
  end

  def free_variables
    @formula_a.free_variables | @formula_b.free_variables
  end

  def free_unification_terms
    @formula_a.free_unification_terms | @formula_b.free_unification_terms
  end

  def replace(old, new)
    return new if eql?(old)
    And.new(@formula_a.replace(old, new), @formula_b.replace(old, new))
  end

  def occurs(unification_term)
    @formula_a.occurs(unification_term) || @formula_b.occurs(unification_term)
  end

  def set_instantiation_time(time)
    @formula_a.set_instantiation_time(time)
    @formula_b.set_instantiation_time(time)
  end

  def to_s
    "#{@formula_a.to_s} ∧ #{@formula_b.to_s}"
  end

  def eql?(exp)
    return false unless exp.is_a?(And)
    @formula_a.eql?(exp.formula_a) && @formula_b.eql?(exp.formula_b)
  end
end
