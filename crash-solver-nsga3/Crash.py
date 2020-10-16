import numpy as np
from pymoo.model.problem import Problem

class Crash(Problem):

    def __init__(self):
        # define lower and upper bounds -  1d array with length equal to number of variable
        xl = np.array([1.0, 1.0, 1.0, 1.0, 1.0])
        xu = np.array([3.0, 3.0, 3.0, 3.0, 3.0]);

        super().__init__(n_var=5, n_obj=3, xl=xl, xu=xu, evaluation_of="auto")


    def _evaluate(self, x, out, *args, **kwargs):

        f1 = 1640.2823 + (2.3573285 * x[:,0]) + (2.3220035 * x[:,1])\
                + (4.5688768 * x[:,2]) + (7.7213633 * x[:,3]) + (4.4559504 * x[:,4])

        f2 = 6.5856 + (1.15 * x[:,0]) - (1.0427 * x[:,1]) + (0.9738 * x[:,2])\
                + (0.8364 * x[:,3]) - (0.3695 * x[:,0] * x[:,3])\
                + (0.0861 * x[:,0] * x[:,4]) + (0.3628 * x[:,1] * x[:,3])\
                - (0.1106 * x[:,0] * x[:,0]) - (0.3437 * x[:,2] * x[:,2])\
                + (0.1764 * x[:,3] * x[:,3])

        f3 = -0.0551 + (0.0181 * x[:,0]) + (0.1024 * x[:,1])\
                + (0.0421 * x[:,2]) - (0.0073 * x[:,0] * x[:,1])\
                + (0.024 * x[:,1] * x[:,2]) - (0.0118 * x[:,1] * x[:,3])\
                - (0.0204 * x[:,2] * x[:,3]) - (0.008 * x[:,2] * x[:,4])\
                - (0.0241 * x[:,1] * x[:,1]) + (0.0109 * x[:,3] * x[:,3])

        out["F"] = np.column_stack([f1, f2, f3])
