class Term
  attr_reader :time, :name
  TIME_DEFAULT = 0
  def initialize(name)
    @name = name
    @time = TIME_DEFAULT
  end

  def free_variables
    raise NotImplementedError
  end

  def free_unification_terms
    raise NotImplementedError
  end

  def replace(old, new)
    raise NotImplementedError
  end

  def occurs(unification_term)
    raise NotImplementedError
  end

  def to_s
    raise NotImplementedError
  end

  def set_instantiation_time(time)
    raise NotImplementedError
  end

  def eql?(term)
    raise NotImplementedError
  end
end
