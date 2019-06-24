require 'rltk'
require_relative 'commands.rb'
require_relative '../language.rb'

class RoverParser < RLTK::Parser
  right :IMPLIES
  left :OR, :AND

  production(:cmd) do
    clause('AXIOMS') { |_| Axioms.new }
    clause('LEMMAS') { |_| Lemmas.new }
    clause('AXIOM noright') { |_, e| Axiom.new(e) }
    clause('LEMMA noright') { |_, e| Lemma.new(e) }
    clause('REMOVE noright') { |_, e| Remove.new(e) }
    clause('RESET') { |_| Reset.new }
    clause('EXIT') { |_| Exit.new }
    clause('noright') { |e| e }
  end

  production(:noright) do
    clause('FORALL SYMBOL PERIOD noright') { |_, s, _, f| ForAll.new(Variable.new(s), f) }
    clause('EXISTS SYMBOL PERIOD noright') { |_, s, _, f| ThereExists.new(Variable.new(s), f) }
    clause('formula') { |e| e }
  end

  production(:formula) do
    clause('formula_with_right OR noright') { |e1, _, e2| Or.new(e1, e2) }
    clause('formula_with_right AND noright') { |e1, _, e2| And.new(e1, e2) }
    clause('formula_with_right IMPLIES noright') { |e1, _, e2| Implies.new(e1, e2) }
    clause('literal') { |e| e }
  end

  production(:formula_with_right) do
    clause('formula_with_right OR formula_with_right') { |e1, _, e2| Or.new(e1, e2) }
    clause('formula_with_right AND formula_with_right') { |e1, _, e2| And.new(e1, e2) }
    clause('formula_with_right IMPLIES formula_with_right') { |e1, _, e2| Implies.new(e1, e2) }
    clause('literal') { |e| e }
  end

  production(:literal) do
    clause('NOT literal') { |_, e| Not.new(e) }
    clause('predicate') { |e| e }
  end

  production(:predicate) do
    clause('SYMBOL') { |s| Predicate.new(s, []) }
    clause('SYMBOL LPAREN RPAREN') { |s, _, _| Predicate.new(s, []) }
    clause('SYMBOL LPAREN term_ls RPAREN') { |s, _, ls, _| Predicate.new(s, ls) }
    clause('LPAREN formula RPAREN') { |_, f, _| f }
  end

  production(:term_ls) do
    clause('term COMMA term_ls') { |t, _, ls| ls.unshift(t) }
    clause('term') { |t| [t] }
  end

  production(:term) do
    clause('SYMBOL') { |s| Variable.new(s) }
    clause('SYMBOL LPAREN RPAREN') { |s, _, _| Function.new(s, []) }
    clause('SYMBOL LPAREN term_ls RPAREN') { |s, _, ls, _| Function.new(s, ls) }
  end

  finalize
end
