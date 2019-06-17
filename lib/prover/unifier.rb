class Unifier
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
