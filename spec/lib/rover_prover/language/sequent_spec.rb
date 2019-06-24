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
  let (:sequent4) { Sequent.new([p], [And.new(q, r), q, r], [], 0) }

  describe 'deepen' do
    before { sequent.right_set_depth(q, 10) }
    it 'does not change the contents of left and right' do
      expect(sequent.deepen).to eql sequent
    end

    it 'saves depth table' do
      expect(sequent.deepen.right_get_depth(q)).to eq 10
    end

    it 'sets up empty siblings if enables siblings' do
      expect(sequent.deepen(enable_siblings: true).siblings).to eq []
    end
  end

  describe 'trivial?' do
    it 'returns true if right and left contains at least one same element' do
      expect(sequent.trivial?).to be true
    end

    it 'returns false if right and left contains no common element' do
      expect(sequent4.trivial?).to be false
    end
  end

  describe 'set_default_instantiation_time' do
    let (:time) { 10 }
    before { sequent.set_default_instantiation_time(time) }
    it 'sets up all instantiation time' do
      expect(sequent.left[0].terms[1].time).to eq(time)
      expect(sequent.right[2].terms[0].time).to eq(time)
    end
  end

  describe 'left_formula' do
    let(:and_t) { And.new(p, q) }
    let(:or_t) { Or.new(p, q) }
    let(:sequent_a) { Sequent.new([and_t, or_t], [p, q], [], 0) }
    before { sequent_a.left_set_depth(and_t, 10) }
    it 'returns left formula whose depth is less than that of others' do
      expect(sequent_a.left_formula).to eq or_t
    end

    it 'returns nil if only predicates are on the left' do
      expect(sequent.left_formula).to be nil
    end
  end

  describe 'right_formula' do
    let(:and_t) { And.new(p, q) }
    let(:or_t) { Or.new(p, q) }
    let(:sequent_a) { Sequent.new([p, q], [and_t, or_t], [], 0) }
    let(:sequent_b) { Sequent.new([p, q], [p, q, r], [], 0) }
    before { sequent_a.right_set_depth(and_t, 10) }
    it 'returns right formula whose depth is less than that of others' do
      expect(sequent_a.right_formula).to eq or_t
    end

    it 'returns nil if only predicates are on the right' do
      expect(sequent_b.right_formula).to be nil
    end
  end

  describe 'left_add' do
    before { sequent.left_add(r) }
    it 'adds formula to left and sets up depth table' do
      expect(sequent.left).to include(r)
      expect(sequent.left_get_depth(r)).to eq 0
    end
  end

  describe 'right_add' do
    before { sequent.right_add(p) }
    it 'adds formula to right and sets up depth table' do
      expect(sequent.right).to include(p)
      expect(sequent.right_get_depth(p)).to eq 0
    end
  end

  describe 'left_remove' do
    before { sequent.left_remove(p) }
    it 'removes formula to left and deletes key in depth table' do
      expect(sequent.left).not_to include(p)
      expect(sequent.left_get_depth(p)).to be nil
    end
  end

  describe 'right_remove' do
    before { sequent.right_remove(r) }
    it 'removes formula to right and deletes key in depth table' do
      expect(sequent.right).not_to include(r)
      expect(sequent.right_get_depth(r)).to be nil
    end
  end

  describe 'left_get_depth, left_set_depth' do
    let(:depth) { 10 }
    before { sequent.left_set_depth(p, depth) }
    it 'sets up depth table correctly' do
      expect(sequent.left_get_depth(p)).to eq depth
    end
  end

  describe 'right_get_depth, right_set_depth' do
    let(:depth) { 10 }
    before { sequent.right_set_depth(q, depth) }
    it 'sets up depth table correctly' do
      expect(sequent.right_get_depth(q)).to eq depth
    end
  end

  describe 'right_remove' do
    before { sequent.right_remove(r) }
    it 'removes formula to right and deletes key in depth table' do
      expect(sequent.right).not_to include(r)
      expect(sequent.right_get_depth(r)).to be nil
    end
  end

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
      expect(pairs[0][0]).to eql q
      expect(pairs[0][1]).to eql q
    end
  end

  describe 'to_s' do
    it 'returns the string expression of the sequent' do
      expect(sequent.to_s).to eq ('p(x, s1), q(x, g(x, y)) ⊢ (q(x, g(x, y)) ∧ r(z, s2)), q(x, g(x, y)), r(z, s2)')
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
