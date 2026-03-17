# PR11.1 Rosetta Starter Corpus

This directory is the PR11.1 language-evaluation corpus.

The milestone boundary is compile-only:

- `safec check`
- `safec emit --ada-out-dir`
- `gprbuild -c`

PR11.1 does not treat this corpus as a proof-bearing milestone. Proof coverage
re-enters later through `PR11.3a`, `PR11.8a`, and `PR11.8b`.

## Status of Current Candidates

Starter corpus:

- `arithmetic/fibonacci.safe`
- `arithmetic/gcd.safe`
- `arithmetic/factorial.safe`
- `arithmetic/collatz_bounded.safe`
- `sorting/bubble_sort.safe`
- `sorting/binary_search.safe`
- `data_structures/bounded_stack.safe`
- `concurrency/producer_consumer.safe`

Candidate expansion:

- `linked_list_reverse.safe`
- `prime_sieve_pipeline.safe`

Deferred:

- `trapezoidal_rule.safe`
- `newton_sqrt_bounded.safe`

## Running the Corpus Gate

Use:

```bash
python3 scripts/run_rosetta_corpus.py
```

That gate validates the eight starter programs through the PR11.1 compile-only
chain. The separate `safe build` smoke in `scripts/run_pr111_language_evaluation_harness.py`
covers executable production on one sequential and one concurrency starter.
