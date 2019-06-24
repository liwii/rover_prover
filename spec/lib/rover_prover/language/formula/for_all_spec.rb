require 'spec_helper'

describe ForAll do
  let (:x_var) { Variable.new('x') }
  let (:y_uni) { UnificationTerm.new('y') }
  let (:z_var) { Variable.new('z') }
  let (:a_var) { Variable.new('a') }
  let (:b_uni) { UnificationTerm.new('b') }
  let (:f) { Function.new('f', [x_var, y_uni, z_var]) }
  let (:p) { Predicate.new('p', [f, z_var]) }
  let (:for_all) { ForAll.new(x_var, p) }
  let (:for_all2) { ForAll.new(z_var, p) }

  describe 'free_variables' do
    it 'returns an array with only var' do
      expect(for_all.free_variables).to match_array [z_var]
    end
  end

  describe 'free_unification_terms' do
    it 'returns an array with only uni' do
      expect(for_all.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    let(:replaced) { ForAll.new(a_var, Predicate.new('p',
                       [
                         Function.new('f', [a_var, y_uni, z_var]),
                         z_var
                       ]))}
    it 'returns new if argument is equal to itself' do
      expect(for_all.replace(for_all, for_all2)).to eql for_all2
    end

    it 'returns itself if argument is not equal to itself' do
      expect(for_all.replace(for_all2, for_all2)).to eql for_all
    end

    it 'replace terms in the expression' do
      expect(for_all.replace(x_var, a_var)).to eql replaced
    end
  end

  describe 'occurs' do
    it "returns true if its terms contain the argument" do
      expect(for_all.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(for_all.occurs(b_uni)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:new_time) { 10 }
    before { for_all.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(for_all.formula.terms.all? { |x| x.time == new_time }).to be true
      expect(for_all.variable.time).to eq new_time
    end
  end

  describe 'to_s' do
    it 'returns ∀, variable, and terms' do
      expect(for_all.to_s).to eq '∀x. p(f(x, y, z), z)'
    end
  end

  describe 'eql?' do
    it "returns true if its variable and terms are same as the argument's" do
      expect(for_all).to eql for_all
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(for_all).not_to eql for_all2
    end

    it "returns false if the argument is not 'ForAll'" do
      expect(for_all).not_to eql f
    end
  end
end
