import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def lhc(n=10, m=2):
    r""" Latin Hyper-cube Sampling (LHS) of `n` points in `m` dimension.
    A very simple LHS code, every point is within `[0.0, 1.0]`.
    Parameters
    ----------
    n : int, optional
        The number of points. Default is 10 when optional.
    m : int
        The number of dimensions. Default is 2 when optional.
    Returns
    -------
    F : ndarray
        A sample of `n` data points in `m` dimension, i.e. `|F| = n x m`.
    """
    d = 1.0 / float(n) ;
    N = np.arange(n)
    F = np.zeros((n, m))
    for i in range(m):
        F[:,i] = (N * d) + (((N + 1.0) * d) - (N * d)) * np.random.random(n)
        np.random.shuffle(F[:,i])
    return F

def lhcl2(n=10, m=2, delta=0.0001):
    r""" Latin Hyper-cube Sampling of `n` points in `m` dimension with L2-norm constraint.
    Latin hypercube sampling n samples of m-dimensional points. This function guarantees 
    that 2-norm of each sample is greater than 0.0001. This function is slower than `lhc()`.
    Every point is within `[0.0, 1.0]`.
    Parameters
    ----------
    n : int
        The number of points.
    m : int
        The number of dimensions.
    Returns
    -------
    F : ndarray
        A sample of `n` data points in `m` dimension, i.e. `|F| = n x m`.
    """
    F = np.zeros((n, m))
    i = 0
    # skip_count = 0
    while i < n:
        k = n - i
        T = lhc(k, m)
        idx = np.argwhere(np.linalg.norm(T, 2, axis = 1) > delta)
        # skip_count += k - idx.shape[0]
        j = i + idx.shape[0]
        if j < n:
            F[i:j,:] = T[0:idx.shape[0],:]
            i = j
        else:
            F[i:,:] = T[0:k,:]
            i += k
    # print('skip_count =', skip_count)
    
    return F

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
