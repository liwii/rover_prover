![Rover](./logo.png)
Rover is an automated theorem prover for first-order logic. For any provable formula, this program is guaranteed to find the proof (eventually). However, as a consequence of the negative answer to Hilbert's *Entscheidungsproblem*, there are some unprovable formulae that will cause this program to loop forever.

To get started, please `gem install rover_prover`:

```
Rover: First-Order Logic Theorem Prover
2019 Koki Ryu
2014 Stephan Boyer
Terms:

  x               (variable)
  f(term, ...)    (function)

Formulae:

  P(term)        (predicate)
  not P          (complement)
  P or Q         (disjunction)
  P and Q        (conjunction)
  P implies Q    (implication)
  forall x. P    (universal quantification)
  exists x. P    (existential quantification)

Enter formulae at the prompt. The following commands are also available for manipulating axioms:

  axioms              (list axioms)
  lemmas              (list lemmas)
  axiom <formula>     (add an axiom)
  lemma <formula>     (prove and add a lemma)
  remove <formula>    (remove an axiom or lemma)
  reset               (remove all axioms and lemmas)

Enter 'exit' command to exit the prompt.

Rover>
```

Example session:
```
Rover> P or not P
0.  ⊢ (P ∨ ¬P)
1.  ⊢ P, ¬P
2. P ⊢ P
Formula proven: (P ∨ ¬P)

Rover> P and not P
0.  ⊢ (P ∧ ¬P)
1.  ⊢ ¬P
2. P ⊢
Formula unprovable: (P ∧ ¬P)

Rover> forall x. P(x) implies (Q(x) implies P(x))
0.  ⊢ (∀x. (P(x) -> (Q(x) -> P(x))))
1.  ⊢ (P(v1) -> (Q(v1) -> P(v1)))
2. P(v1) ⊢ (Q(v1) -> P(v1))
3. P(v1), Q(v1) ⊢ P(v1)
Formula proven: (∀x. (P(x) -> (Q(x) -> P(x))))

Rover> exists x. (P(x) implies forall y. P(y))
0.  ⊢ (∃x. (P(x) -> (∀y. P(y))))
1.  ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t1) -> (∀y. P(y)))
2.  ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t1) -> (∀y. P(y))), (P(t2) -> (∀y. P(y)))
3. P(t1) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t2) -> (∀y. P(y))), (∀y. P(y))
4. P(t1) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t2) -> (∀y. P(y))), (∀y. P(y)), (P(t3) -> (∀y. P(y)))
5. P(t1), P(t2) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (∀y. P(y)), (P(t3) -> (∀y. P(y))), (∀y. P(y))
6. P(t1), P(t2) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t3) -> (∀y. P(y))), (∀y. P(y)), P(v1)
7. P(t1), P(t2) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (P(t3) -> (∀y. P(y))), (∀y. P(y)), P(v1), (P(t4) -> (∀y. P(y)))
8. P(t1), P(t2), P(t3) ⊢ (∃x. (P(x) -> (∀y. P(y)))), (∀y. P(y)), P(v1), (P(t4) -> (∀y. P(y))), (∀y. P(y))
9. P(t1), P(t2), P(t3) ⊢ (∃x. (P(x) -> (∀y. P(y)))), P(v1), (P(t4) -> (∀y. P(y))), (∀y. P(y)), P(v2)
10. P(t1), P(t2), P(t3) ⊢ (∃x. (P(x) -> (∀y. P(y)))), P(v1), (P(t4) -> (∀y. P(y))), (∀y. P(y)), P(v2), (P(t5) -> (∀y. P(y)))
11. P(t1), P(t2), P(t3), P(t4) ⊢ (∃x. (P(x) -> (∀y. P(y)))), P(v1), (∀y. P(y)), P(v2), (P(t5) -> (∀y. P(y))), (∀y. P(y))
t4 = v1
Formula proven: (∃x. (P(x) -> (∀y. P(y))))

Rover> axiom forall x. Equals(x, x)
Axiom added: (∀x. Equals(x, x))

Rover> axioms
(∀x. Equals(x, x))

Rover> lemma Equals(a, a)
0. (∀x. Equals(x, x)) ⊢ Equals(a, a)
1. (∀x. Equals(x, x)), Equals(t1, t1) ⊢ Equals(a, a)
t1 = a
Lemma proven: Equals(a, a)

Rover> lemmas
Equals(a, a)

Rover> remove forall x. Equals(x, x)
Axiom removed: (∀x. Equals(x, x))
Dependent axioms are also removed:
Equals(a, a)
```
