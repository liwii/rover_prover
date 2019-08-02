require_relative 'unifier.rb'
require_relative '../language.rb'

class Prover
  def prove_formula(axioms, formula)
    prove(
      Sequent.new(
        axioms,
        [formula],
        nil,
        0
      )
    )
  end

  def prove(sequent)
    sequent.set_default_instantiation_time(0)
    unifier = Unifier.new

    frontier = [sequent]
    proven = []
    while true do
      frontier = frontier - proven
      old = frontier.pop
      break if old.nil?
      puts "#{old.depth}. #{old.to_s}"

      if old.trivial?
        proven.push(old)
        next
      end

      unless old.siblings.nil?
        pairs_list = old.siblings.map(&:get_unifiable_pairs)
        if pairs_list.all? { |list| !list.empty? }
          subst = unifier.unify_all(pairs_list)
          unless subst.nil?
            subst.each { |k, v| puts "#{k.to_s} = #{v.to_s}" }
            proven = proven | old.siblings
            frontier = frontier - proven
            next
          end
        else
          old.siblings.delete(old)
        end
      end

      left = old.left_formula
      right = old.right_formula
      return false if left.nil? && right.nil?

      if apply_left?(old, left, right)
        frontier.push(*derivation_left(old, left))
      else
        frontier.push(*derivation_right(old, right))
      end
    end
    true
  end

  def derivation_left(old, left)
    return derivation_left_not(old, left) if left.is_a?(Not)
    return derivation_left_and(old, left) if left.is_a?(And)
    return derivation_left_or(old, left) if left.is_a?(Or)
    return derivation_left_implies(old, left) if left.is_a?(Implies)
    return derivation_left_for_all(old, left) if left.is_a?(ForAll)
    return derivation_left_there_exists(old, left) if left.is_a?(ThereExists)
    []
  end

  def derivation_right(old, right)
    return derivation_right_not(old, right) if right.is_a?(Not)
    return derivation_right_and(old, right) if right.is_a?(And)
    return derivation_right_or(old, right) if right.is_a?(Or)
    return derivation_right_implies(old, right) if right.is_a?(Implies)
    return derivation_right_for_all(old, right) if right.is_a?(ForAll)
    return derivation_right_there_exists(old, right) if right.is_a?(ThereExists)
    []
  end

  def derivation_left_not(sequent, left)
    new = sequent.deepen
    new.left_remove(left)
    new.right_add(left.formula)
    new.right_set_depth(left.formula, (sequent.left_get_depth(left) + 1))
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_left_and(sequent, left)
    new = sequent.deepen
    new.left_remove(left)
    left_depth = sequent.left_get_depth(left)
    new.left_add(left.formula_a)
    new.left_set_depth(left.formula_a, left_depth + 1)
    new.left_add(left.formula_b)
    new.left_set_depth(left.formula_b, left_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_left_or(sequent, left)
    new_a = sequent.deepen
    new_b = sequent.deepen
    new_a.left_remove(left)
    new_b.left_remove(left)
    left_depth = sequent.left_get_depth(left)
    new_a.left_add(left.formula_a)
    new_a.left_set_depth(left.formula_a, left_depth + 1)
    new_b.left_add(left.formula_b)
    new_b.left_set_depth(left.formula_b, left_depth + 1)
    unless new_a.siblings.nil?
      new_a.siblings.push(new_a)
    end
    unless new_b.siblings.nil?
      new_b.siblings.push(new_b)
    end
    [new_a, new_b]
  end

  def derivation_left_implies(sequent, left)
    new_a = sequent.deepen
    new_b = sequent.deepen
    new_a.left_remove(left)
    new_b.left_remove(left)
    left_depth = sequent.left_get_depth(left)
    new_a.right_add(left.formula_a)
    new_a.right_set_depth(left.formula_a, left_depth + 1)
    new_b.left_add(left.formula_b)
    new_b.left_set_depth(left.formula_b, left_depth + 1)
    unless new_a.siblings.nil?
      new_a.siblings.push(new_a)
    end
    unless new_b.siblings.nil?
      new_b.siblings.push(new_b)
    end
    [new_a, new_b]
  end

  def derivation_left_for_all(sequent, left)
    new = sequent.deepen(enable_siblings: true)
    left_depth = sequent.left_get_depth(left)
    new.left_set_depth(left, left_depth + 1)
    t = UnificationTerm.new(sequent.get_variable_name('t'))
    t.set_instantiation_time(sequent.depth + 1)
    formula = left.formula.replace(
      left.variable,
      t
    )
    unless new.left.include?(formula)
      new.left_add(formula)
      new.left_set_depth(formula, left_depth + 1)
    end
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_left_there_exists(sequent, left)
    new = sequent.deepen
    new.left_remove(left)
    left_depth = sequent.left_get_depth(left)
    variable = Variable.new(sequent.get_variable_name('v'))
    variable.set_instantiation_time(sequent.depth + 1)
    formula = left.formula.replace(left.variable, variable)
    new.left_add(formula)
    new.left_set_depth(formula, left_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_right_not(sequent, right)
    new = sequent.deepen
    new.right_remove(right)
    new.left_add(right.formula)
    new.left_set_depth(right.formula, (sequent.right_get_depth(right) + 1))
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_right_and(sequent, right)
    new_a = sequent.deepen
    new_b = sequent.deepen
    new_a.right_remove(right)
    new_b.right_remove(right)
    right_depth = sequent.right_get_depth(right)
    new_a.right_add(right.formula_a)
    new_a.right_set_depth(right.formula_a, right_depth + 1)
    new_b.right_add(right.formula_b)
    new_b.right_set_depth(right.formula_b, right_depth + 1)
    unless new_a.siblings.nil?
      new_a.siblings.push(new_a)
    end
    unless new_b.siblings.nil?
      new_b.siblings.push(new_b)
    end
    [new_a, new_b]
  end

  def derivation_right_or(sequent, right)
    new = sequent.deepen
    new.right_remove(right)
    right_depth = sequent.right_get_depth(right)
    new.right_add(right.formula_a)
    new.right_set_depth(right.formula_a, right_depth + 1)
    new.right_add(right.formula_b)
    new.right_set_depth(right.formula_b, right_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_right_implies(sequent, right)
    new = sequent.deepen
    new.right_remove(right)
    right_depth = sequent.right_get_depth(right)
    new.left_add(right.formula_a)
    new.left_set_depth(right.formula_a, right_depth + 1)
    new.right_add(right.formula_b)
    new.right_set_depth(right.formula_b, right_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_right_for_all(sequent, right)
    new = sequent.deepen
    new.right_remove(right)
    right_depth = sequent.right_get_depth(right)
    variable = Variable.new(sequent.get_variable_name('v'))
    variable.set_instantiation_time(sequent.depth + 1)
    formula = right.formula.replace(right.variable, variable)
    new.right_add(formula)
    new.right_set_depth(formula, right_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  def derivation_right_there_exists(sequent, right)
    new = sequent.deepen(enable_siblings: true)
    right_depth = sequent.right_get_depth(right)
    new.right_set_depth(right, right_depth + 1)
    t = UnificationTerm.new(sequent.get_variable_name('t'))
    t.set_instantiation_time(sequent.depth + 1)
    formula = right.formula.replace(
      right.variable,
      t
    )
    unless new.right.include?(formula)
      new.right_add(formula)
    end
    new.right_set_depth(formula, right_depth + 1)
    unless new.siblings.nil?
      new.siblings.push(new)
    end
    [new]
  end

  private
  def apply_left?(sequent, left, right)
    return true if right.nil?
    return false if left.nil?
    sequent.right_get_depth(right) > sequent.left_get_depth(left)
  end
end
