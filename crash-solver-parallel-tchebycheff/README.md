## MATLAB code to generate Pareto-front for the Vehicle Crash problem

### Generating reference directions

 - To generate `N` reference directions using Das-Dennis, use `$ python3 ./src/gen_refs.py N 3 das-dennis`
 - To generate `N` reference directions using LHS, use `$ python3 ./src/gen_refs.py N 3 lhc`
 - The generated reference directions will be saved in `./data/refs-das-dennis.csv` and `./data/refs-lhc.csv`

### To find solutions in serial

 - Change the appropriate place to point to the correct file for reference direction on line 1 of `solver.m`
 - Run matlab scripts `solver.m`
 - If you want to run the experiment in parallel, make `N > 1` in `crash_parallel_solver()`

### Results:
    
The results will be stored in `data` folder. `F`, `X`, `G` and `CV` values will be stored in individual `.mat` and `.csv` file. 
