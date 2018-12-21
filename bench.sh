#!/bin/bash
FNC=${1-2clsp}
PFX=${2-echo}
2clsp () {
  for e in bench.sh nevergrad/benchmark/experiments.py  nevergrad/optimization/optimizerlib.py; do
    $PFX rsync -av $e clsp:~/project/nevergrad/$e
  done
}

bench () {
  r=(10 400 50 10)
  b=(noise compabasedillcond illcond discrete)
  for i in {0..2}; do
    $PFX python -m nevergrad.benchmark ${b[$i]} --repetitions=${r[$i]} --num_workers=48 --seed=12 --plot
  done
}

replot () {
  # Workflow to concatenate results starting from second line of
  # existing csv and then recreating the plots.
  for e in noise ; do # illcond compabasedillcond
    rm -rf ${e}_plots
    tail +2 tmp/$e.csv >> $e.csv #
    python -m nevergrad.benchmark.plotting $e.csv
  done
}
$FNC
