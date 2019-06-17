require 'spec_helper'

describe Unifier do
  describe 'unify_list' do
    let (:x) { Variable.new('x') }
    let (:y) { Variable.new('y') }
    let (:s) { UnificationTerm.new('s') }
    let (:t) { UnificationTerm.new('t') }
    let (:f) { Function.new('f', [x, s]) }
    let (:g) { Function.new('g', [x, y]) }
    let (:h) { Function.new('h', [x, g]) }
    let (:l1) { [x, y, h] }
    let (:l2) { [x, y, f] }
    let (:l3) { [t, y, s] }
    let (:u) { Unifier.new }

    it 'returns nil if any one of the terms cannot be unified' do
      expect(u.unify_list(l3.zip(l2))).to be nil
    end

    it 'returns substitution if all the terms can be unified' do
      result = u.unify_list(l3.zip(l1))
      expect(result[t]).to eql x
      expect(result[s]).to eql h
    end
  end
end
