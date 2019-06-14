require_relative '../formulae.rb'

class Not
  attr_reader :formulae
  include Expression

  def initialize(formulae)
    @formulae = formulae
  end

  def free_variables
    @formulae.free_variables
  end

  def free_unification_terms
    @formulae.free_unification_terms
  end

  def replace(old, new)
    return new if eql?(old)
    Not.new(@formulae.replace(old, new))
  end

  def set_instantiation_time(time)
    @formulae.set_instantiation_time(time)
  end

  def occurs(unification_term)
    @formulae.occurs(unification_term)
  end

  def to_s
    "¬#{@formulae.to_s}"
  end

  def eql?(exp)
    return false unless exp.is_a?(Not)
    @formulae.eql?(exp.formulae)
  end
end
