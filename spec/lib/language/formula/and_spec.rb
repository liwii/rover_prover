require 'spec_helper'

describe And do
  let (:x_var) { Variable.new('x') }
  let (:y_uni) { UnificationTerm.new('y') }
  let (:z_var) { Variable.new('z') }
  let (:f) { Function.new('f', [x_var, y_uni]) }
  let (:f2) { Function.new('f', [x_var, x_var]) }
  let (:p) { Predicate.new('p', [f, x_var]) }
  let (:p2) { Predicate.new('p', [f2, x_var]) }
  let (:q) { Predicate.new('q', [f, x_var]) }
  let (:n_p) { Not.new(p) }
  let (:a1) { And.new(p, q) }
  let (:a2) { And.new(p, n_p) }

  describe 'free_variables' do
    it 'returns an array with only var' do
      expect(a2.free_variables).to match_array [x_var]
    end
  end

  describe 'free_unification_terms' do
    it 'returns an array with only uni' do
      expect(a2.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    it 'returns new if argument is equal to itself' do
      expect(a1.replace(a1, a2)).to eql a2
    end

    it 'returns itself if argument is not equal to itself' do
      expect(a1.replace(a2, a2)).to eql a1
    end

    it 'replace terms in the expression' do
      expect(a1.replace(q, n_p)).to eql a2
    end
  end

  describe 'occurs' do
    it "returns true if its terms contain the argument" do
      expect(a1.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(a1.occurs(z_var)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:new_time) { 10 }
    before { a1.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(a1.formula_a.terms.all? { |x| x.time == new_time }).to be true
      expect(a1.formula_b.terms.all? { |x| x.time == new_time }).to be true
    end
  end

  describe 'to_s' do
    it 'returns its name and terms' do
      expect(a1.to_s).to eq '(p(f(x, y), x) ∧ q(f(x, y), x))'
    end
  end

  describe 'eql?' do
    it "returns true if its name and terms are same as the argument's" do
      expect(a1).to eql a1
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(a1).not_to eql a2
    end

    it "returns false if the argument is not 'And'" do
      expect(a1).not_to eql f
    end
  end
end
