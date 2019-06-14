require_relative '../formula.rb'

class Not
  attr_reader :formula
  include Expression

  def initialize(formula)
    @formula = formula
  end

  def free_variables
    @formula.free_variables
  end

  def free_unification_terms
    @formula.free_unification_terms
  end

  def replace(old, new)
    return new if eql?(old)
    Not.new(@formula.replace(old, new))
  end

  def set_instantiation_time(time)
    @formula.set_instantiation_time(time)
  end

  def occurs(unification_term)
    @formula.occurs(unification_term)
  end

  def to_s
    "¬#{@formula.to_s}"
  end

  def eql?(exp)
    return false unless exp.is_a?(Not)
    @formula.eql?(exp.formula)
  end
end
