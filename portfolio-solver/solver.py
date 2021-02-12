import sys
import numpy as np
import autograd.numpy as anp

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_reference_directions
from pymoo.optimize import minimize

from Portfolio import Portfolio, symbols, load, normalize, returns, stats

if __name__ == "__main__":
    Q = load(symbols)
    Qn = normalize(Q)
    Qr = returns(Qn)
    (rmean, rstd, rcov) = stats(Qr)

    print("rmean:", rmean)
    print("rstd:", rstd)
    print("rcov:", rcov)

    # create the reference directions to be used for the optimization
    ref_dirs = get_reference_directions("das-dennis", 4, n_partitions=35)
    print("ref_dirs:", ref_dirs.shape)
    # sys.exit(0)

    # create the algorithm object
    algorithm = NSGA3(pop_size=ref_dirs.shape[0], ref_dirs=ref_dirs)

    # execute the optimization
    problem = Portfolio((rmean, rstd, rcov))
    res = minimize(problem, algorithm, seed=1, termination=('n_gen', 2000), verbose=True)

    if res.X is not None:
        np.savetxt("x.csv", res.X, delimiter=',', fmt='%1.4e')
        np.savetxt("f.csv", res.F, delimiter=',', fmt='%1.4e')
        np.savetxt("g.csv", res.G, delimiter=',', fmt='%1.4e')
        np.savetxt("cv.csv", res.CV, delimiter=',', fmt='%1.4e')
    else:
        print("Error: no solution found, X is empty.")

