import sys
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from viz.utils.sampling import lhc, lhcl2, das_dennis

def simplex(n=10, m=2, mode='lhcl2', delta=0.001):
    if mode == 'lhc':
        F = lhc(n=n, m=m)
        # project them onto a unit simplex
        F = (F.T / F.sum(axis=1)).T
    elif mode == 'lhcl2':
        F = lhcl2(n=n, m=m, delta=delta)
        # project them onto a unit simplex
        F = (F.T / F.sum(axis=1)).T
    elif mode == "das-dennis":
        F = das_dennis(n=n, m=m, manifold='simplex')
    return F

if __name__ == "__main__":
    print(sys.argv)
    n = 1000
    m = 3
    mode = "lhc"
    if len(sys.argv) == 4:
        n = int(sys.argv[1])
        m = int(sys.argv[2])
        mode = sys.argv[3]

    F = simplex(n, m, mode=mode)
    print(F.shape)

    fig = plt.figure()
    ax = Axes3D(fig)
    ax.scatter(F[:,0], F[:,1], F[:,2])
    plt.show()

    np.savetxt('./data/refs-{0:s}.csv'.format(mode), F, delimiter=',', fmt='%1.4e')
