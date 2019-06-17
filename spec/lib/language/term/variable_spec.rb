require 'spec_helper'

describe Variable do
  describe 'new' do
    let (:x) { Variable.new('x') }
    it 'has 0 as the time just after initialization' do
      expect(x.time).to eq 0
    end
  end

  describe 'free_variables' do
    let (:x) { Variable.new('x') }
    it 'returns array with only itself' do
      expect(x.free_variables).to match_array [x]
    end
  end

  describe 'free_unification_terms' do
    let (:x) { Variable.new('x') }
    it 'returns empty array' do
      expect(x.free_unification_terms).to match_array []
    end
  end

  describe 'replace' do
    let (:x1) { Variable.new('x') }
    let (:x2) { Variable.new('x') }
    let (:y) { Variable.new('y') }
    let (:z) { Variable.new('z') }

    it 'returns new if argument is equal to itself' do
      expect(x1.replace(x2, y)).to eql y
    end

    it 'returns itself if argument is not equal to itself' do
      expect(x1.replace(z, y)).to eql x1
    end
  end

  describe 'occurs' do
    let (:x) { Variable.new('x') }
    let (:x_unification) { UnificationTerm.new('x') }
    it 'returns false' do
      expect(x.occurs(x_unification)).to be false
    end
  end

  describe 'set_instantiation_time' do
    let (:x) { Variable.new('x') }
    let (:new_time) { 10 }
    before { x.set_instantiation_time(new_time) }
    it 'updates time' do
      expect(x.time).to eq new_time
    end
  end

  describe 'to_s' do
    let (:x) { Variable.new('x') }
    it 'returns its name' do
      expect(x.to_s).to eq 'x'
    end
  end

  describe 'eql?' do
    let (:x1) { Variable.new('x') }
    let (:x2) { Variable.new('x') }
    let (:y) { Variable.new('y') }
    let (:x_unification) { UnificationTerm.new('x') }

    it "returns true if its name is same as the argument's" do
      expect(x1).to eql x2
    end

    it "returns false if its name is different from the argument's" do
      expect(x1).not_to eql y
    end

    it "returns false if the class of the argument is not Variable" do
      expect(x1).not_to eql x_unification
    end
  end

  describe 'unify' do
    let (:x) { Variable.new('x') }
    let (:y) { Variable.new('y') }
    let (:x_fun) { Function.new('x', []) }

    it 'returns nil if the argument is not variable' do
      expect(x.unify(x_fun)).to be nil
    end

    it 'returns nil if the argument is not equal to itself' do
      expect(x.unify(y)).to be nil
    end

    it 'returns empty hash if the argument is equal to itself' do
      expect(x.unify(x)).to eq({})
    end
  end
end
