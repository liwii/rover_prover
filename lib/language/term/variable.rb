require_relative '../term.rb'

class Variable < Term
  def free_variables
    [self]
  end

  def free_unification_terms
    []
  end

  def replace(old, new)
    return new if eql?(old)
    self
  end

  def occurs(unification_term)
    false
  end

  def set_instantiation_time(time)
    @time = time
  end

  def to_s
    @name
  end

  def eql?(var)
    return false unless var.is_a?(Variable)
    @name == var.name
  end
end
