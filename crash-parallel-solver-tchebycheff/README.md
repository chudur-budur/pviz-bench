## MATLAB code to generate Pareto-front for the Vehicle Crash problem

### Generating reference directions

 - To generate 3112 reference directions using Das-Dennis and LHS, use `$ ./bin/genrefs.sh`
 - The generated reference directions will be saved in `data`

### To find 3112 solutions in serial

 - Assuming, you have access to a SLURM cluster.
 - To find solutions from Das-Dennis, use `$ sbatch bin/crash-das-solver.sb`
 - To find solutions from LHS, use `$ sbatch bin/crash-lhs-solver.sb`

### Results:
    
The results will be stored in `data` folder. `F`, `X`, `G` and `CV` values will be stored in individual `.mat` and `.csv` file. 
