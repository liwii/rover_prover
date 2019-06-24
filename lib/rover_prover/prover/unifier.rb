require 'pry'
class Unifier

  def unify_all(pairs_list)
    lengths = pairs_list.map { |pair| (0..(pair.length - 1)).to_a }
    first = lengths.shift
    indexes = first.product(*lengths)
    indexes.each do |index|
      possible_pairs = pairs_list.map.with_index { |pairs, i| pairs[index[i]] }
      subst = unify_list(possible_pairs)
      return subst unless subst.nil?
    end
    nil
  end

  def unify_list(pairs)
    substitution = {}
    pairs.each do |a, b|
      substitution.each do |k, v|
        a = a.replace(k, v)
        b = b.replace(k, v)
      end
      sub = a.unify(b)
      return nil if sub.nil?
      substitution.merge!(sub)
    end
    substitution
  end
end
