require_relative 'terms.rb'

class Function < Term
  attr_reader :terms
  def initialize(name, terms)
    super(name)
    @terms = terms
  end

  def free_variables
    @terms.map(&:free_variables).flatten.uniq
  end

  def free_unification_terms
    @terms.map(&:free_unification_terms).flatten.uniq
  end

  def replace(old, new)
    return new if eql?(old)
    Function.new(@name, @terms.map { |term| term.replace(old, new) })
  end

  def set_instantiation_time(time)
    @time = time
    @terms.each{ |term| term.set_instantiation_time(time) }
  end

  def occurs(unification_term)
    @terms.any? { |term| term.occurs(unification_term) }
  end


  def eql?(function)
    return false unless function.is_a?(Function)
    return false unless @name == function.name
    return false unless @terms.length == function.terms.length
    @terms.zip(function.terms).all? { |t1, t2| t1 == t2 }
  end

  def to_s
    "#{@name}(#{@terms.map(&:to_s).join(', ')})"
  end

end
