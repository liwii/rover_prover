class Sequent
  attr_reader :left, :right, :siblings, :depth
  def initialize(left, right, siblings, depth)
    @left = left
    @right = right
    @siblings = siblings
    @depth = depth
  end

  def free_variables
    @left.map { |formula| formula.free_variables }.flatten | @right.map { |formula| formula.free_variables}.flatten
  end

  def free_unification_terms
    @left.map { |formula| formula.free_unification_terms }.flatten | @right.map { |formula| formula.free_unification_terms}.flatten
  end

  def get_variable_name(prefix)
    names = free_variables.map(&:name) | free_unification_terms.map(&:name)
    index = 1
    name = prefix + index.to_s
    while names.include?(name) do
      index += 1
      name = prefix + index.to_s
    end
    name
  end

  def get_unifiable_pairs
    pairs = []
    @left.each do |formula_a|
      @right.each do |formula_b|
        pairs.push([formula_a, formula_b]) unless formula_a.unify(formula_b).nil?
      end
    end
    pairs
  end

  def to_s
    "#{@left.map(&:to_s).join(', ')} ⊢ #{@right.map(&:to_s).join(', ')}"
  end

  def eql?(sequent)
    include?(@left, sequent.left) &&
    include?(@right, sequent.right) &&
    include?(sequent.left, @left) &&
    include?(sequent.right, @right)
  end

  private
  def include?(formulas1, formulas2)
    formulas2.all? do |f2|
      formulas1.any? { |f1| f1.eql?(f2) }
    end
  end
end
