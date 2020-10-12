import numpy as np
import sys

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_problem, get_reference_directions
from pymoo.optimize import minimize
from GAA import GAA


if __name__ == "__main__":
    # create the reference directions to be used for the optimization
    ref_dirs = get_reference_directions("das-dennis", 10, n_partitions=5)
    print("ref_dirs.size =", ref_dirs.size)
    # sys.exit(0)

    # create the algorithm object
    algorithm = NSGA3(pop_size=ref_dirs.size, ref_dirs=ref_dirs)

    # execute the optimization
    res = minimize(GAA(), algorithm, seed=1, termination=('n_gen', 1000), verbose=True)

    # save the results
    if res.X is not None:
        np.savetxt("x-das.csv", res.X, delimiter=',', fmt='%1.4e')
        np.savetxt("f-das.csv", res.F, delimiter=',', fmt='%1.4e')
        np.savetxt("g-das.csv", res.G, delimiter=',', fmt='%1.4e')
        np.savetxt("cv-das.csv", res.CV, delimiter=',', fmt='%1.4e')
    else:
        print("Error: no solution found, X is empty.")
