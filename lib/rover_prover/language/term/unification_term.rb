require_relative '../term.rb'

class UnificationTerm < Term
  def free_variables
    []
  end

  def free_unification_terms
    [self]
  end

  def replace(old, new)
    return new if eql?(old)
    self
  end

  def occurs(unification_term)
    eql?(unification_term)
  end

  def set_instantiation_time(time)
    @time = time
  end

  def to_s
    @name
  end

  def eql?(uni)
    return false unless uni.is_a?(UnificationTerm)
    @name == uni.name
  end

  def unify(term)
    return nil if term.occurs(self) || @time > term.time
    { self => term }
  end
end
