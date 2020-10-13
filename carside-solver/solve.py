import numpy as np

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_problem, get_reference_directions
from pymoo.optimize import minimize
from pymoo.visualization.scatter import Scatter

# create the reference directions to be used for the optimization
ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=40)
print("ref_dirs.shape =", ref_dirs.shape)

# create the algorithm object
algorithm = NSGA3(pop_size=ref_dirs.shape[0], ref_dirs=ref_dirs)

# execute the optimization
res = minimize(get_problem("carside"), algorithm, seed=1, termination=('n_gen', 1000), verbose=True)

# save the results
np.savetxt("x.csv", res.X, delimiter=',', fmt='%1.4e')
np.savetxt("f.csv", res.F, delimiter=',', fmt='%1.4e')
np.savetxt("g.csv", res.G, delimiter=',', fmt='%1.4e')
np.savetxt("cv.csv", res.CV, delimiter=',', fmt='%1.4e')
