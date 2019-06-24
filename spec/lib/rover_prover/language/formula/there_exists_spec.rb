require 'spec_helper'

describe ThereExists do
  let (:x_var) { Variable.new('x') }
  let (:y_uni) { UnificationTerm.new('y') }
  let (:z_var) { Variable.new('z') }
  let (:a_var) { Variable.new('a') }
  let (:b_uni) { UnificationTerm.new('b') }
  let (:f) { Function.new('f', [x_var, y_uni, z_var]) }
  let (:p) { Predicate.new('p', [f, z_var]) }
  let (:there_exists) { ThereExists.new(x_var, p) }
  let (:there_exists2) { ThereExists.new(z_var, p) }

  describe 'free_variables' do
    it 'returns an array with only var' do
      expect(there_exists.free_variables).to match_array [z_var]
    end
  end

  describe 'free_unification_terms' do
    it 'returns an array with only uni' do
      expect(there_exists.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    let(:replaced) { ThereExists.new(a_var, Predicate.new('p',
                       [
                         Function.new('f', [a_var, y_uni, z_var]),
                         z_var
                       ]))}
    it 'returns new if argument is equal to itself' do
      expect(there_exists.replace(there_exists, there_exists2)).to eql there_exists2
    end

    it 'returns itself if argument is not equal to itself' do
      expect(there_exists.replace(there_exists2, there_exists2)).to eql there_exists
    end

    it 'replace terms in the expression' do
      expect(there_exists.replace(x_var, a_var)).to eql replaced
    end
  end

  describe 'occurs' do
    it "returns true if its terms contain the argument" do
      expect(there_exists.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(there_exists.occurs(b_uni)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:new_time) { 10 }
    before { there_exists.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(there_exists.formula.terms.all? { |x| x.time == new_time }).to be true
      expect(there_exists.variable.time).to eq new_time
    end
  end

  describe 'to_s' do
    it 'returns ∃, variable, and terms' do
      expect(there_exists.to_s).to eq '(∃x. p(f(x, y, z), z))'
    end
  end

  describe 'eql?' do
    it "returns true if its variable and terms are same as the argument's" do
      expect(there_exists).to eql there_exists
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(there_exists).not_to eql there_exists2
    end

    it "returns false if the argument is not 'ThereExists'" do
      expect(there_exists).not_to eql f
    end
  end
end
