require 'rltk'
require_relative 'commands.rb'
require_relative '../language.rb'

class RoverParser < RLTK::Parser
  right :IMPLIES
  left :OR, :AND

  production(:cmd) do
    clause('AXIOMS') { |_| Axioms.new }
    clause('LEMMAS') { |_| Lemmas.new }
    clause('AXIOM formula') { |_, e| Axiom.new(e) }
    clause('LEMMA formula') { |_, e| Lemma.new(e) }
    clause('REMOVE formula') { |_, e| Remove.new(e) }
    clause('RESET') { |_| Reset.new }
    clause('EXIIT') { |_| Exit.new }
    clause('formula') { |e| e }
  end

  production(:formula) do
    clause('FORALL SYMBOL PERIOD formula') { |_, s, _, f| ForAll.new(Variable.new(s), f) }
    clause('EXISTS SYMBOL PERIOD formula') { |_, s, _, f| ThereExists.new(Variable.new(s), f) }
    clause('formula OR formula') { |e1, _, e2| Or.new(e1, e2) }
    clause('formula AND formula') { |e1, _, e2| And.new(e1, e2) }
    clause('formula IMPLIES formula') { |e1, _, e2| Implies.new(e1, e2) }
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
