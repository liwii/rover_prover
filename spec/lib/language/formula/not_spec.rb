require 'spec_helper'

describe Not do
  let (:x_var) { Variable.new('x') }
  let (:y_uni) { UnificationTerm.new('y') }
  let (:z_var) { Variable.new('z') }
  let (:f) { Function.new('f', [x_var, y_uni]) }
  let (:f3) { Function.new('f', [x_var, x_var]) }
  let (:p) { Predicate.new('p', [f, x_var]) }
  let (:p2) { Predicate.new('p', [f, x_var]) }
  let (:p3) { Predicate.new('p', [f3, x_var]) }
  let (:p_fun) { Function.new('p', []) }
  let (:q) { Predicate.new('q', [f, x_var]) }
  let (:n_p) { Not.new(p) }
  let (:n_p2) { Not.new(p2) }
  let (:n_p3) { Not.new(p3) }
  let (:n_q) { Not.new(q) }

  describe 'free_variables' do
    it 'returns an array with only var' do
      expect(n_p.free_variables).to match_array [x_var]
    end
  end

  describe 'free_unification_terms' do
    it 'returns an array with only uni' do
      expect(n_p.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    it 'returns new if argument is equal to itself' do
      expect(n_p.replace(n_p, n_q)).to eql n_q
    end

    it 'returns itself if argument is not equal to itself' do
      expect(n_p.replace(n_q, n_q)).to eql n_p
    end

    it 'replace terms in the function' do
      expect(n_p.replace(p, q).formula).to eql q
    end
  end

  describe 'occurs' do
    it "returns true if its terms contain the argument" do
      expect(n_p.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(n_p.occurs(z_var)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:new_time) { 10 }
    before { n_p.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(n_p.formula.terms.all? { |x| x.time == new_time }).to be true
    end
  end

  describe 'to_s' do
    it 'returns its name and terms' do
      expect(n_p.to_s).to eq '¬p(f(x, y), x)'
    end
  end

  describe 'eql?' do
    it "returns true if its name and terms are same as the argument's" do
      expect(p).to eql p2
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(p).not_to eql p3
    end

    it "returns false if the name of the functions are different" do
      expect(p).not_to eql q
    end

    it "returns false if the argument is not a function" do
      expect(p).not_to eql p_fun
    end
  end
  describe 'free_variables' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:p) { Predicate.new('p', [f, x_var] ) }
    it 'returns an array with only var' do
      expect(p.free_variables).to match_array [x_var]
    end
  end

  describe 'free_unification_terms' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:p) { Predicate.new('p', [f, x_var] ) }
    it 'returns an array with only uni' do
      expect(p.free_unification_terms).to match_array [y_uni]
    end
  end

  describe 'replace' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:f2) { Function.new('f', [x_var, x_var]) }
    let (:p) { Predicate.new('p', [f, x_var] ) }
    let (:p2) { Predicate.new('p', [f, x_var] ) }
    let (:q) { Predicate.new('q', [f] ) }

    it 'returns new if argument is equal to itself' do
      expect(p.replace(p2, q)).to eql q
    end

    it 'returns itself if argument is not equal to itself' do
      expect(p.replace(q, q)).to eql p
    end

    it 'replace terms in the function' do
      expect(p.replace(y_uni, x_var).terms.first).to eql f2
    end
  end

  describe 'occurs' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:z_var) { Variable.new('z') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:p) { Predicate.new('p', [f, x_var]) }
    it "returns true if its terms contain the argument" do
      expect(p.occurs(y_uni)).to be true
    end
    it "returns false if none of its terms is equal to the argument" do
      expect(p.occurs(z_var)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:x_var) { Variable.new('x') }
    let (:y_uni) { UnificationTerm.new('y') }
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:p) { Predicate.new('p', [f, x_var]) }
    let (:new_time) { 10 }
    before { p.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(p.terms.all? { |x| x.time == new_time }).to be true
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
    let (:f) { Function.new('f', [x_var, y_uni]) }
    let (:f3) { Function.new('f', [x_var, x_var]) }
    let (:p) { Predicate.new('p', [f, x_var]) }
    let (:p2) { Predicate.new('p', [f, x_var]) }
    let (:p3) { Predicate.new('p', [f3, x_var]) }
    let (:p_fun) { Function.new('p', []) }
    let (:q) { Predicate.new('q', [f, x_var]) }

    it "returns true if its name and terms are same as the argument's" do
      expect(n_p).to eql n_p2
    end

    it "returns false if its terms aredifferent from the argument's" do
      expect(n_p).not_to eql n_p3
    end

    it "returns false if the name of the functions are different" do
      expect(n_p).not_to eql n_q
    end

    it "returns false if the argument is not a 'not'" do
      expect(n_p).not_to eql p
    end
  end
end
