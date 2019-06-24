require 'spec_helper'

describe Unifier do
  let (:x) { Variable.new('x') }
  let (:y) { Variable.new('y') }
  let (:s) { UnificationTerm.new('s') }
  let (:t) { UnificationTerm.new('t') }
  let (:f) { Function.new('f', [x, s]) }
  let (:g) { Function.new('g', [x, y]) }
  let (:h) { Function.new('h', [x, g]) }
  let (:u) { Unifier.new }

  describe 'unify_all' do
    let (:ll1) { [[[f, s], [t, x]], [[f, s], [s, y]]] }
    let (:ll2) { [[[f, s], [t, x]], [[f, t], [t, y]]] }

    it 'returns substitution if it can unify one set of pairs selected from each pairs' do
      result = u.unify_all(ll1)
      expect(result[t]).to eql x
      expect(result[s]).to eql y
    end

    it 'returns nil if any product of pairs cannot be unified' do
      expect(u.unify_all(ll2)).to be nil
    end
  end

  describe 'unify_list' do
    let (:l1) { [x, y, h] }
    let (:l2) { [x, y, f] }
    let (:l3) { [t, y, s] }
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
