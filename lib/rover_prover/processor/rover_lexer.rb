require 'rltk'

class RoverLexer < RLTK::Lexer
  rule(/axioms/) { :AXIOMS }
  rule(/lemmas/) { :LEMMAS }
  rule(/axiom/) { :AXIOM }
  rule(/lemma/) { :LEMMA }
  rule(/remove/) { :REMOVE }
  rule(/reset/) { :RESET }
  rule(/exit/) { :EXIT }
  rule(/\(/) { :LPAREN }
  rule(/\)/) { :RPAREN }
  rule(/\./) { :PERIOD }
  rule(/,/) { :COMMA }
  rule(/not/) { :NOT }
  rule(/and/) { :AND }
  rule(/or/) { :OR }
  rule(/implies/) { :IMPLIES }
  rule(/forall/) { :FORALL }
  rule(/exists/) { :EXISTS }
  rule(/[a-zA-Z][a-zA-Z0-9]*/) { |t| [:SYMBOL, t] }
  rule(/\s/)
end
