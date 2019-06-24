require_relative 'rover_prover/processor/processor.rb'
require_relative 'rover_prover/prover/prover.rb'
require 'pry'

module Rover
  module Main
    def self.run
      message = <<~MSG
        Rover: First-Order Logic Theorem Prover
        2019 Koki Ryu
        2014 Stephan Boyer
        Terms:

          x               (variable)
          f(term, ...)    (function)

        Formulae:

          P(term)        (predicate)
          not P          (complement)
          P or Q         (disjunction)
          P and Q        (conjunction)
          P implies Q    (implication)
          forall x. P    (universal quantification)
          exists x. P    (existential quantification)

        Enter formulae at the prompt. The following commands are also available for manipulating axioms:

          axioms              (list axioms)
          lemmas              (list lemmas)
          axiom <formula>     (add an axiom)
          lemma <formula>     (prove and add a lemma)
          remove <formula>    (remove an axiom or lemma)
          reset               (remove all axioms and lemmas)

        Enter 'exit' command to exit the prompt.
      MSG

      puts message

      axioms = []
      lemmas = {}

      prover = Prover.new

      while true do
        begin
          print("\nRover> ")
          cmd = gets
          if cmd.nil?
            puts 'Bye'
            return
          end
          cmd_token = RoverParser.parse(RoverLexer.lex(cmd))
          if cmd_token.is_a?(Axioms)
            axioms.each { |axiom| puts axiom.to_s }
          elsif cmd_token.is_a?(Lemmas)
            lemmas.keys.each { |lemma| puts lemma.to_s }
          elsif cmd_token.is_a?(Axiom)
            axioms.push(cmd_token.formula)
            puts "Axiom added: #{cmd_token.formula.to_s}"
          elsif cmd_token.is_a?(Lemma)
            result = prover.prove_formula(axioms | lemmas.keys, cmd_token.formula)
            if result
              lemmas[cmd_token.formula] = axioms.dup
              puts "Lemma proven: #{cmd_token.formula.to_s}"
            else
              puts "Lemma unprovable: #{cmd_token.formula.to_s}"
            end
          elsif cmd_token.is_a?(Remove)
            result = axioms.reject! { |axiom| axiom.eql?(cmd_token.formula) }
            if result.nil?
              puts "Not an axiom: #{cmd_token.formula.to_s}"
            else
              puts "Axiom removed: #{cmd_token.formula.to_s}"
              bad_lemmas = lemmas.keys.select { |key| lemmas[key].any?{ |lemma| lemma.eql?(cmd_token.formula) } }
              puts "Dependent axioms are also removed:"
              bad_lemmas.each do |lemma|
                lemmas.delete(lemma)
                puts lemma.to_s
              end
            end
          elsif cmd_token.is_a?(Reset)
            axioms = []
            lemmas = {}
          elsif cmd_token.is_a?(Exit)
            puts 'Bye'
            return
          else
            result = prover.prove_formula(axioms | lemmas.keys, cmd_token)
            if result
              puts "Formula proven: #{cmd_token.to_s}"
            else
              puts "Formula unprovable: #{cmd_token.to_s}"
            end
          end


        rescue Interrupt
          next
        rescue RLTK::LexingError => e
          puts "Error: Unable to parse #{e.remainder}"
          next
        rescue RLTK::NotInLanguage
          puts 'Error: Invalid command'
          next
        end
      end
    end
  end
end
