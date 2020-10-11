#!/bin/bash

if [ -d "data" ]; then
    rm -rf data
    mkdir data
fi

cd src

echo "Generating 3112 reference directions suing Das-Dennis"
matlab -nodisplay -nodesktop -nosplash -r "gen_das_dennis"

echo "Generating 3112 reference directions suing LHS"
matlab -nodisplay -nodesktop -nosplash -r "gen_lhs"

echo "done"
