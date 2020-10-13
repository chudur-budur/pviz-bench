import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from viz.utils.sampling import lhc, lhcl2

def simplex(n=10, m=2, mode='lhcl2', delta=0.001):
    F = lhc(n=10, m=m)
    if mode == 'lhcl2':
        F = lhcl2(n=n, m=m, delta=delta)
    # project them onto a unit simplex
    F_ = np.linalg.norm(F, 2, axis=1)
    F = (F.T / F_).T 
    return F

if __name__ == "__main__":
    F = simplex(100, 3)
    print(F.shape)

    fig = plt.figure()
    ax = Axes3D(fig)
    ax.scatter(F[:,0], F[:,1], F[:,2])
    plt.show()
