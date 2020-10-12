import numpy as np

from pymoo.algorithms.nsga3 import NSGA3
from pymoo.factory import get_problem, get_reference_directions
from pymoo.optimize import minimize
from pymoo.visualization.scatter import Scatter

# create the reference directions to be used for the optimization
ref_dirs = get_reference_directions("das-dennis", 3, n_partitions=35)
print(ref_dirs.size)

# create the algorithm object
algorithm = NSGA3(pop_size=1998, ref_dirs=ref_dirs)

# execute the optimization
res = minimize(get_problem("carside"), algorithm, seed=1, termination=('n_gen', 600), verbose=True)

# save the results
np.savetxt("f.csv", res.F, delimiter=',', fmt='%1.4e')
np.savetxt("g.csv", res.G, delimiter=',', fmt='%1.4e')
np.savetxt("x.csv", res.X, delimiter=',', fmt='%1.4e')
