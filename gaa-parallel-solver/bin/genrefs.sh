#!/bin/bash

$ROOT=$HOME/data/research/pviz-bench/gaa-parallel-solver
if [ -d "$ROOT/data" ]; then
    rm -rf "$ROOT/data";
    mkdir "$ROOT/data";
else
    mkdir "$ROOT/data";
fi

cd $ROOT/src

echo "Generating 3112 reference directions suing Das-Dennis"
matlab -nodisplay -nodesktop -nosplash -r "gen_das_dennis"

echo "Generating 3112 reference directions suing LHS"
matlab -nodisplay -nodesktop -nosplash -r "gen_lhs"

echo "done"
