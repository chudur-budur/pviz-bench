## MATLAB code to generate Pareto-front for the GAA problem

### Generating reference directions

 - To generate 5005 reference directions using Das-Dennis use `$ python3 ./bin/gen_refs.py 5005 10 das-dennis`
 - To generate 5005 reference directions using LHS use `$ python3 ./bin/gen_refs.py 5005 10 lhcl2`
 - The generated reference directions will be saved in `./data/refs-das-dennis.csv` and `./data/refs-lhcl2.csv`

### To find solutions in parallel

 - Assuming, you have access to a SLURM cluster.
 - To find solutions from Das-Dennis, use `$ sbatch bin/gaa-das-dennis.sb`
 - To find solutions from LHS, use `$ sbatch bin/gaa-lhcl2.sb`

### Results:
    
The results will be stored in `data` folder. `F`, `X`, `G` and `CV` values will be stored in individual `.mat` and `.csv` file. 
