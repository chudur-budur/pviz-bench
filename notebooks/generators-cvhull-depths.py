"""generators-cvhull-depths.py -- a python script from generators-cvhull-depths.ipynb to be run on hpcc.

    Just a copy of `generators-cvhull-depths.ipynb` as a python script.
    You need to use the slurm submission script to run this code on hpcc.
    The submission script is `run-generators-cvhull-depth-on-hpc.sb`. Please
    change the hw resource parameters in the files according to your need.

    We are doing it because in some datasets, it takes a very long time to 
    compute the depth contours.
"""

import sys
import os
import numpy as np
from viz.tda import simple_shape
from viz.utils import io

pfs = {'dtlz2': ['3d', '4d', '8d'], \
       'dtlz2-nbi': ['3d', '4d', '8d'], \
       'debmdk': ['3d', '4d', '8d'], \
       'debmdk-nbi': ['3d', '4d', '8d'], \
       'debmdk-all': ['3d', '4d', '8d'], \
       'debmdk-all-nbi': ['3d', '4d', '8d'], \
       'dtlz8': ['3d', '4d', '6d', '8d'], \
       'dtlz8-nbi': ['3d', '4d', '6d', '8d'], \
       'c2dtlz2': ['3d', '4d', '5d', '8d'], \
       'c2dtlz2-nbi': ['3d', '4d', '5d', '8d'], \
       'cdebmdk': ['3d', '4d', '8d'], \
       'cdebmdk-nbi': ['3d', '4d', '8d'], \
       'c0dtlz2': ['3d', '4d', '8d'], \
       'c0dtlz2-nbi': ['3d', '4d', '8d'], \
       'carside-nbi': ['3d'], \
       'crash-nbi': ['3d'], 'crash-c1-nbi': ['3d'], 'crash-c2-nbi': ['3d'], \
       'gaa-fmincon': ['10d'], 'gaa-fmincon-nbi': ['10d'], \
       'gaa-nsga3': ['10d'], 'gaa-nsga3-nbi': ['10d']}

for pf in list(pfs.keys())[-2:]:
    for dim in pfs[pf]:
        fullpathf = "../data/{0:s}/{1:s}/f.csv".format(pf, dim)
        if os.path.exists(fullpathf):
            path, filenamef = os.path.split(fullpathf)
            dirs = path.split('/')
            frontname = dirs[-2]

            F = np.loadtxt(fullpathf, delimiter=',')
            print(fullpathf, F.shape, dirs, frontname)
            
            # test simple_shape.depth_contour function
            # it looks like these PFs are better displayed if project_collapse=False
            if pf in ['dtlz8', 'dtlz8-nbi', 'crash-nbi', 'crash-c1-nbi', 'crash-c2-nbi']:
                L = simple_shape.depth_contours(F, project_collapse=False)
            elif pf in ['gaa-fmincon', 'gaa-fmincon-nbi', 'gaa-nsga3', 'gaa-nsga3-nbi']:
                L = simple_shape.depth_contours(F, verbose=True)
            else:
                L = simple_shape.depth_contours(F)
            # save the layers
            io.savetxt(os.path.join(path, "depth-cont-cvhull.csv"), L, fmt='{:d}', delimiter=',')
