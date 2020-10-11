#!/bin/bash

if [ -d "data" ]; then
    rm -rf data
    mkdir data
fi

echo "Generating 3112 reference directions suing Das-Dennis"
matlab -nodisplay -nodesktop -nosplash -r "./src/save_layer"

echo "Generating 3112 reference directions suing LHS"
matlab -nodisplay -nodesktop -nosplash -r "./src/save_lhs"

echo "done"
