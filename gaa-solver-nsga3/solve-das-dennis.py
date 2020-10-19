import numpy as np
import sys

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_problem, get_reference_directions
from pymoo.optimize import minimize
from GAA import GAA


if __name__ == "__main__":
    # create the reference directions to be used for the optimization
    refs = get_reference_directions("das-dennis", 10, n_partitions=7)
    print(refs[0:3])
    print("refs.shape =", refs.shape)
    ref_dirs = simplex(refs.shape[0], 10)
    print(ref_dirs[0:3])
    print("ref_dirs.shape =", ref_dirs.shape)
    sys.exit(0)

    # create the algorithm object
    algorithm = NSGA3(pop_size=ref_dirs.shape[0], ref_dirs=ref_dirs)

    # execute the optimization
    res = minimize(GAA(), algorithm, seed=1, termination=('n_gen', 8000), verbose=True)

    # save the results
    if res.X is not None:
        np.savetxt("x-das.csv", res.X, delimiter=',', fmt='%1.4e')
        np.savetxt("f-das.csv", res.F, delimiter=',', fmt='%1.4e')
        np.savetxt("g-das.csv", res.G, delimiter=',', fmt='%1.4e')
        np.savetxt("cv-das.csv", res.CV, delimiter=',', fmt='%1.4e')
    else:
        print("Error: no solution found, X is empty.")
