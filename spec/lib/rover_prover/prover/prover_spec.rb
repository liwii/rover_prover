require 'spec_helper'

describe Prover do
  let (:prover) { Prover.new }
  let (:x) { Variable.new('x') }
  let (:y) { Variable.new('y') }
  let (:z) { Variable.new('z') }
  let (:t) { UnificationTerm.new('t') }
  let (:v) { Variable.new('v') }
  let (:s1) { UnificationTerm.new('s1') }
  let (:s2) { UnificationTerm.new('s2') }
  let (:p) { Predicate.new('p', [x, s1]) }
  let (:g) { Function.new('g', [x, y]) }
  let (:q) { Predicate.new('q', [x, g]) }
  let (:r) { Predicate.new('r', [z, s2]) }

  describe 'prove_formula' do
    let(:a) { Predicate.new('A', []) }
    let(:b) { Predicate.new('B', []) }
    let(:x) { Variable.new('x') }
    let(:y) { Variable.new('y') }

    def p(variables)
      Predicate.new('P', variables)
    end

    def q(variables)
      Predicate.new('Q', variables)
    end

    let (:prover) { Prover.new }
    subject (:result) { prover.prove_formula(axioms, formula) }

    context 'provable formula 1' do
      let (:axioms) { [] }
      let (:formula) {
        Implies.new(
          And.new( Not.new(Not.new(a)), Implies.new(a, b)),
          b
        )
      }
      it { is_expected.to be true }
    end

    context 'provable formula 2' do
      let (:axioms) { [] }
      let (:formula) {
        ThereExists.new(
          x,
          Implies.new(
            p([x]),
            ForAll.new(y, p([y]))
          )
        )
      }
      it { is_expected.to be true }
    end

    context 'provable formula 3' do
      let (:axioms) { 
        [ForAll.new(x, Implies.new(q([y]), p([x])))]
      }
      let (:formula) {
        Implies.new(q([y]), ForAll.new(x, p([x])))
      }
      it { is_expected.to be true }
    end

    context 'provable formula 4' do
      let (:axioms) { 
        []
      }
      let (:formula) {
        ThereExists.new(y, Implies.new(q([x]), q([y])))
      }
      it { is_expected.to be true }
    end

    context 'unprovable formula 1' do
      let (:axioms) { [] }
      let (:formula) {
        Implies.new(
          Implies.new(a, b),
          Implies.new(Not.new(a), b)
        )
      }
      it { is_expected.to be false }
    end

    context 'unprovable formula 2' do
      let (:axioms) { 
        [ThereExists.new(x, p([x]))]
      }
      let (:formula) {
        ForAll.new(x, p([x]))
      }
      it { is_expected.to be false }
    end
  end

  describe 'prove' do
    let(:a) { Predicate.new('A', []) }
    let(:b) { Predicate.new('B', []) }
    let(:x) { Variable.new('x') }
    let(:y) { Variable.new('y') }
    def p(variables)
      Predicate.new('P', variables)
    end

    def q(variables)
      Predicate.new('Q', variables)
    end

    let (:sequent) { Sequent.new(axioms, formulae, nil, 0) }
    let (:prover) { Prover.new }
    subject (:result) { prover.prove(sequent) }

    context 'provable formula 1' do
      let (:axioms) { [] }
      let (:formulae) {
        [Implies.new(
          And.new( Not.new(Not.new(a)), Implies.new(a, b)),
          b
        )]
      }
      it { is_expected.to be true }
    end

    context 'provable formula 2' do
      let (:axioms) { [] }
      let (:formulae) {
        [
          ThereExists.new(
            x,
            Implies.new(
              p([x]),
              ForAll.new(y, p([y]))
            )
          )
        ]
      }
      it { is_expected.to be true }
    end

    context 'provable formula 3' do
      let (:axioms) { 
        [ForAll.new(x, Implies.new(q([y]), p([x])))]
      }
      let (:formulae) {
        [Implies.new(q([y]), ForAll.new(x, p([x])))]
      }
      it { is_expected.to be true }
    end

    context 'unprovable formula 1' do
      let (:axioms) { [] }
      let (:formulae) {
        [Implies.new(
          Implies.new(a, b),
          Implies.new(Not.new(a), b)
        )]
      }
      it { is_expected.to be false }
    end

    context 'unprovable formula 2' do
      let (:axioms) { 
        [ThereExists.new(x, p([x]))]
      }
      let (:formulae) {
        [ForAll.new(x, p([x]))]
      }
      it { is_expected.to be false }
    end
  end

  describe 'derivation_left_not' do
    let (:not_p) { Not.new(p) }
    let (:sequent) { Sequent.new([not_p, q], [r], [], 0) }

    subject (:new_sequent) { prover.derivation_left_not(sequent, not_p).first }
    it 'follows left not derivation rule' do
      is_expected.to eql (Sequent.new([q], [p, r], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_left_and' do
    let (:and_p_q) { And.new(p, q) }
    let (:sequent) { Sequent.new([and_p_q], [r], [], 0) }

    subject (:new_sequent) { prover.derivation_left_and(sequent, and_p_q).first }
    it 'follows left and derivation rule' do
      is_expected.to eql (Sequent.new([p, q], [r], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_left_or' do
    let (:or_p_q) { Or.new(p, q) }
    let (:sequent) { Sequent.new([or_p_q], [r], [], 0) }

    subject (:new_sequents) { prover.derivation_left_or(sequent, or_p_q) }
    it 'follows left or derivation rule' do
      expect(subject[0]).to eql (Sequent.new([p], [r], [], 0))
      expect(subject[1]).to eql (Sequent.new([q], [r], [], 0))
    end

    it 'increments depth' do
      expect(subject[0].depth).to eq 1
      expect(subject[1].depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject[0].siblings.last).to eql subject[0]
      expect(subject[1].siblings.last).to eql subject[1]
    end
  end

  describe 'derivation_left_implies' do
    let (:implies_p_q) { Implies.new(p, q) }
    let (:sequent) { Sequent.new([implies_p_q], [r], [], 0) }

    subject (:new_sequents) { prover.derivation_left_implies(sequent, implies_p_q) }
    it 'follows left implies derivation rule' do
      expect(subject[0]).to eql (Sequent.new([], [r, p], [], 0))
      expect(subject[1]).to eql (Sequent.new([q], [r], [], 0))
    end

    it 'increments depth' do
      expect(subject[0].depth).to eq 1
      expect(subject[1].depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject[0].siblings.last).to eql subject[0]
      expect(subject[1].siblings.last).to eql subject[1]
    end
  end

  describe 'derivation_left_for_all' do
    let (:for_all) { ForAll.new(x, Predicate.new('pp', [x, t])) }
    let (:sequent) { Sequent.new([for_all], [r], [], 0) }

    subject (:new_sequents) { prover.derivation_left_for_all(sequent, for_all).first }
    it 'follows left forall derivation rule' do
      is_expected.to eql (Sequent.new([for_all, Predicate.new('pp', [UnificationTerm.new('t1'), t])], [r], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_left_there_exists' do
    let (:there_exists) { ThereExists.new(x, Predicate.new('pp', [x, v])) }
    let (:sequent) { Sequent.new([there_exists], [r], [], 0) }

    subject (:new_sequents) { prover.derivation_left_there_exists(sequent, there_exists).first }
    it 'follows left thereexists derivation rule' do
      is_expected.to eql (Sequent.new([Predicate.new('pp', [Variable.new('v1'), v])], [r], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_right_not' do
    let (:not_p) { Not.new(p) }
    let (:sequent) { Sequent.new([r], [not_p, q], [], 0) }

    subject (:new_sequent) { prover.derivation_right_not(sequent, not_p).first }

    it 'follows right not derivation rule' do
      is_expected.to eql (Sequent.new([p, r], [q], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_right_and' do
    let (:and_p_q) { And.new(p, q) }
    let (:sequent) { Sequent.new([r], [and_p_q], [], 0) }

    subject (:new_sequents) { prover.derivation_right_and(sequent, and_p_q) }
    it 'follows right and derivation rule' do
      expect(subject[0]).to eql (Sequent.new([r], [p], [], 0))
      expect(subject[1]).to eql (Sequent.new([r], [q], [], 0))
    end

    it 'increments depth' do
      expect(subject[0].depth).to eq 1
      expect(subject[1].depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject[0].siblings.last).to eql subject[0]
      expect(subject[1].siblings.last).to eql subject[1]
    end
  end

  describe 'derivation_right_or' do
    let (:or_p_q) { Or.new(p, q) }
    let (:sequent) { Sequent.new([r], [or_p_q], [], 0) }

    subject (:new_sequent) { prover.derivation_right_or(sequent, or_p_q).first }
    it 'follows right or derivation rule' do
      is_expected.to eql (Sequent.new([r], [p, q],[], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_right_implies' do
    let (:implies_p_q) { Implies.new(p, q) }
    let (:sequent) { Sequent.new([r], [implies_p_q], [], 0) }

    subject (:new_sequent) { prover.derivation_right_implies(sequent, implies_p_q).first }
    it 'follows right implies derivation rule' do
      is_expected.to eql (Sequent.new([p, r], [q], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_right_there_exists' do
    let (:there_exists) { ThereExists.new(x, Predicate.new('pp', [x, t])) }
    let (:sequent) { Sequent.new([r], [there_exists], [], 0) }

    subject (:new_sequents) { prover.derivation_right_there_exists(sequent, there_exists).first }
    it 'follows right thereexists derivation rule' do
      is_expected.to eql (Sequent.new([r], [there_exists, Predicate.new('pp', [UnificationTerm.new('t1'), t])], [ ], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end

  describe 'derivation_right_for_all' do
    let (:for_all) { ForAll.new(x, Predicate.new('pp', [x, v])) }
    let (:sequent) { Sequent.new([r], [for_all], [], 0) }

    subject (:new_sequents) { prover.derivation_right_for_all(sequent, for_all).first }
    it 'follows right forall derivation rule' do
      is_expected.to eql (Sequent.new([r], [Predicate.new('pp', [Variable.new('v1'), v])], [], 0))
    end

    it 'increments depth' do
      expect(subject.depth).to eq 1
    end

    it 'adds itself to siblings' do
      expect(subject.siblings.last).to eql subject
    end
  end
end
