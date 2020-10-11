#!/bin/bash

if [ -d "data" ]; then
    rm -rf "data";
    mkdir "data";
else
    mkdir "data";
fi

cd src

echo "Generating 3112 reference directions using Das-Dennis"
matlab -nodisplay -nodesktop -nosplash -r "gen_das_dennis"

echo "Generating 3112 reference directions using LHS"
matlab -nodisplay -nodesktop -nosplash -r "gen_lhs"

echo "done"
