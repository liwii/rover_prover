require_relative './formula/formulae.rb'
class Sequent
  attr_reader :left, :right, :siblings, :depth
  def initialize(left, right, siblings, depth)
    @left = []
    @right = []
    @left_depth_tbl = {}
    @right_depth_tbl = {}
    left.each { |l| left_add(l) }
    right.each { |l| right_add(l) }
    @siblings = siblings
    @depth = depth
  end

  def deepen(enable_siblings: false)
    new_siblings = @siblings.nil? ? (enable_siblings ? [] : @siblings): @siblings.dup
    new = Sequent.new(@left.dup, @right.dup, new_siblings, @depth + 1)
    @left.each do |formula|
      new.left_set_depth(formula, left_get_depth(formula))
    end
    @right.each do |formula|
      new.right_set_depth(formula, right_get_depth(formula))
    end
    new
  end

  def trivial?
    (@left & @right).length > 0
  end

  def set_default_instantiation_time(time)
    @left.each { |l| l.set_instantiation_time(time) }
    @right.each { |r| r.set_instantiation_time(time) }
  end

  def left_formula
    @left.reject { |f| f.is_a?(Predicate) }.min_by { |f| left_get_depth(f) }
  end

  def right_formula
    @right.reject { |f| f.is_a?(Predicate) }.min_by { |f| right_get_depth(f) }
  end

  def left_add(l)
    @left.push(l)
    @left_depth_tbl[l] = 0
  end

  def right_add(r)
    @right.push(r)
    @right_depth_tbl[r] = 0
  end

  def left_remove(l)
    @left.delete(l)
    @left_depth_tbl.delete(l)
  end

  def right_remove(r)
    @right.delete(r)
    @right_depth_tbl.delete(r)
  end

  def left_get_depth(l)
    @left_depth_tbl[l]
  end

  def right_get_depth(r)
    @right_depth_tbl[r]
  end

  def left_set_depth(l, t)
    @left_depth_tbl[l] = t
  end

  def right_set_depth(r, t)
    @right_depth_tbl[r] = t
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
