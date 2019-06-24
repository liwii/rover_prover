class Axioms
end

class Lemmas
end

class Axiom
  attr_reader :formula
  def initialize(formula)
    @formula = formula
  end
end

class Lemma
  attr_reader :formula
  def initialize(formula)
    @formula = formula
  end
end

class Remove
  attr_reader :formula
  def initialize(formula)
    @formula = formula
  end
end

class Reset
end

class Exit
end
