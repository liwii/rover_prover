require 'spec_helper'

describe Sequent do
  let (:x) { Variable.new('x') }
  let (:y) { Variable.new('y') }
  let (:z) { Variable.new('z') }
  let (:s1) { UnificationTerm.new('s1') }
  let (:s2) { UnificationTerm.new('s2') }
  let (:p) { Predicate.new('p', [x, s1]) }
  let (:g) { Function.new('g', [x, y]) }
  let (:q) { Predicate.new('q', [x, g]) }
  let (:r) { Predicate.new('r', [z, s2]) }
  let (:sequent) { Sequent.new([p, q], [And.new(q, r), q, r], [], 0) }
  let (:sequent2) { Sequent.new([p, q], [And.new(q, r), q, r], [], 0) }
  let (:sequent3) { Sequent.new([p, r], [And.new(q, r), q, r], [], 0) }

  describe 'free_variables' do
    it 'contains all the variables in the right and the left' do
      variables = sequent.free_variables
      [x, y, z].each do |el|
        expect(variables.any? { |v| v.eql?(el) }).to be true
      end
    end
  end

  describe 'free_unification_terms' do
    it 'contains all the unification_terms in the right and the left' do
      unification_terms = sequent.free_unification_terms
      [s1, s2].each do |el|
        expect(unification_terms.any? { |v| v.eql?(el) }).to be true
      end
    end
  end

  describe 'get_variable_name' do
    it 'suggests a variable name without conflicts' do
      expect(sequent.get_variable_name('s')).to eq 's3'
    end
  end

  describe 'get_unifiable_pairs' do
    it 'suggests all unifiable pairs' do
      pairs = sequent.get_unifiable_pairs
      expect(pairs[0][0]).to eql p
      expect(pairs[0][1]).to eql q
      expect(pairs[1][0]).to eql q
      expect(pairs[1][1]).to eql q
    end
  end

  describe 'to_s' do
    it 'returns the string expression of the sequent' do
      expect(sequent.to_s).to eq ('p(x, s1), q(x, g(x, y)) ⊢ q(x, g(x, y)) ∧ r(z, s2), q(x, g(x, y)), r(z, s2)')
    end
  end

  describe 'eql' do
    it 'returns true if two sequents are the same except for the order' do
      expect(sequent.eql?(sequent2)).to be true
    end

    it 'returns false if two sequents are different' do
      expect(sequent.eql?(sequent3)).to be false
    end
  end
end
