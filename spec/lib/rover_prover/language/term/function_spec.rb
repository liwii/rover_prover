require 'spec_helper'

describe Function do
  describe 'new' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    it 'has 0 as the time just after initialization' do
      expect(f.time).to eq 0
    end
  end

  describe 'free_variables' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, x_var, y_uni]) }
    it 'returns an array with only var' do
      expect(f.free_variables).to match_array [x_var]
    end
  end

  describe 'free_unification_terms' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    it 'returns an array with only uni' do
      expect(f.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:f2) { Function.new('f', [x_var, y_uni]) }
    let (:g) { Function.new('g', [x_var, x_var]) }

    it 'returns new if argument is equal to itself' do
      expect(f.replace(f2, g)).to eql g
    end

    it 'returns itself if argument is not equal to itself' do
      expect(f.replace(g, g)).to eql f
    end

    it 'replace terms in the function' do
      expect(f.replace(y_uni, x_var).terms).to match_array([x_var, x_var])
    end
  end

  describe 'occurs' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:z_var) { Variable.new('z') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    it "returns true if its terms contain the argument" do
      expect(f.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(f.occurs(z_var)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:new_time) { 10 }
    before { f.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(f.time).to eq new_time
      expect(f.terms.all? { |x| x.time == new_time }).to be true
    end
  end

  describe 'to_s' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    it 'returns its name and terms' do
      expect(f.to_s).to eq 'f(x, y)'
    end
  end

  describe 'eql?' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f_var) { Variable.new('f') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:f2) { Function.new('f', [x_var, y_uni]) }
    let (:f3) { Function.new('f', [x_var, x_var]) }
    let (:g) { Function.new('g', [x_var, y_uni]) }

    it "returns true if its name and terms are same as the argument's" do
      expect(f).to eql f2
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(f).not_to eql f3
    end

    it 'returns false if the name of the functions are different' do
      expect(f).not_to eql g
    end

    it 'returns false if the argument is not a function' do
      expect(f).not_to eql f_var
    end
  end

  describe 'unify' do
    let (:x) { Variable.new('x') }
    let (:y) { Variable.new('y') }
    let (:s) { UnificationTerm.new('s') }
    let (:f) { Function.new('f', [s, x]) }
    let (:g) { Function.new('g', [x, y]) }
    let (:f2) { Function.new('f', [g, x]) }
    let (:f3) { Function.new('f', [s, x, s]) }
    it 'returns nil if the argument is not function' do
      expect(f.unify(x)).to be nil
    end

    it 'returns nil if the name of the argument is not the same as that of itself' do
      expect(f.unify(g)).to be nil
    end

    it 'returns nil if the number of terms in the argument is not the same as that of itself' do
      expect(f.unify(f3)).to be nil
    end

    it 'returns the result of unification otherwise' do
      expect(f.unify(f2)).to include( { s => g } )
    end
  end
end
