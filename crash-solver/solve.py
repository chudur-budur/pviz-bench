import numpy as np
import sys

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_problem, get_reference_directions
from pymoo.optimize import minimize
from Crash import Crash


if __name__ == "__main__":
    # create the reference directions to be used for the optimization
    ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=100)
    print("ref_dirs.shape =", ref_dirs.shape)
    # sys.exit(0)

    # create the algorithm object
    algorithm = NSGA3(pop_size=ref_dirs.shape[0], ref_dirs=ref_dirs)

    # execute the optimization
    res = minimize(Crash(), algorithm, seed=1, termination=('n_gen', 1000), verbose=True)

    # save the results
    np.savetxt("f.csv", res.F, delimiter=',', fmt='%1.4e')
    np.savetxt("x.csv", res.X, delimiter=',', fmt='%1.4e')
