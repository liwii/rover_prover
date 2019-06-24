require_relative '../formula.rb'

class ForAll < Formula
  attr_reader :variable, :formula

  def initialize(variable, formula)
    @variable = variable
    @formula = formula
  end

  def free_variables
    @formula.free_variables.reject{ |var| var.eql?(@variable) }
  end

  def free_unification_terms
    @formula.free_unification_terms
  end

  def replace(old, new)
    return new if eql?(old)
    ForAll.new(
      @variable.replace(old, new),
      @formula.replace(old, new)
    )
  end

  def occurs(unification_term)
    @formula.occurs(unification_term)
  end

  def set_instantiation_time(time)
    @variable.set_instantiation_time(time)
    @formula.set_instantiation_time(time)
  end

  def to_s
    "(∀#{@variable.to_s}. #{@formula.to_s})"
  end

  def eql?(exp)
    return false unless exp.is_a?(ForAll)
    @variable.eql?(exp.variable) && @formula.eql?(exp.formula)
  end
end
