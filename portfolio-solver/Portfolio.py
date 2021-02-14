import numpy as np
from scipy.stats import norm
import autograd.numpy as anp
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import pandas as pd
from pymoo.model.problem import Problem

symbols = ['aapl', 'adbe', 'amzn', 'csco', 'ea', 'fb', 'intc', 'msft', 'nflx', 'nvda', 'pypl', 'tsla']

def load(symbols):
    Q = {}
    for i in range(len(symbols)):
        path = r'./quotes/' + symbols[i] + r'.csv'
        Df = pd.read_csv(path)
        Df[Df.columns[1:]] = Df[Df.columns[1:]].replace('[\$,]', '', regex=True).astype(float)
        Q[symbols[i]] = Df
    return Q

def normalize(Q):
    Q_ = {}
    for q in list(Q.keys()):
        Df = Q[q].copy()
        lb,ub = np.max(Df[Df.columns[1:]]), np.min(Df[Df.columns[1:]])
        Df[Df.columns[1:]] = (Df[Df.columns[1:]] - lb) / (ub - lb)
        Q_[q] = Df
    return Q_

def returns(Q):
    Q_ = {}
    for q in list(Q.keys()):
        Df = Q[q].copy()
        C = Df[Df.columns[1]].to_numpy()
        R = np.insert(np.diff(C), 0, 0, axis=0)
        # R = (R / (C-R))
        Df['Return'] = R
        Q_[q] = Df
    return Q_
        
def stats(Q):
    Df = Q[list(Q.keys())[0]]
    rmean = np.zeros(len(Q))
    rstd = np.zeros(len(Q))
    R = np.zeros((Df.shape[0], len(Q)))
    for i,q in enumerate(list(Q.keys())):
        Df = Q[q]
        r = Df[Df.columns[-1]].to_numpy()
        rmean[i] = np.mean(r)
        rstd[i] = np.std(r)
        R[:,i] = r
    rcov = np.cov(R.T)
    return (rmean, rstd, rcov)

class Portfolio(Problem):

    def __init__(self, params):
        super().__init__(n_var=len(symbols), n_obj=4, n_constr=1, type_var=anp.float)
        
        # define lower and upper bounds -  1d array with length equal to number of variable
        self.xl = anp.zeros(self.n_var)
        self.xu = anp.ones(self.n_var)
        self.alpha = 0.05
        if params is not None:
            self.rmean = params[0]
            self.rstd = params[1]
            self.rcov = params[2]

    def _evaluate(self, X, out, *args, **kwargs):
        
        # get return
        return_ = np.sum(self.rmean * X, axis=1)

        # get risk
        risk = np.zeros(X.shape[0])
        for k in range(X.shape[0]):
            risk[k] = np.dot(X[k], np.dot(X[k].T, self.rcov))
            
        # get value at risk (VaR)
        var = 1 - norm.ppf(self.alpha, 1 + return_, np.sqrt(risk))
        
        # get conditional value at risk (CVaR)
        cvar = (self.alpha**-1) * norm.pdf(norm.ppf(self.alpha)) * np.sqrt(risk) - return_
          
        # obj. 5
        min_th = np.sum(X < 0.08, axis=1)

        # obj 6
        max_th = np.sum(X > 0.9, axis=1)
                    
        # budget constraint
        g1 = np.sum(X, axis=1) - 1

        # out["F"] = anp.column_stack([-return_, var, max_th, min_th])
        out["F"] = anp.column_stack([-return_, var, cvar, min_th])
        out["G"] = g1 # anp.column_stack([g1, g2])

if __name__ == "__main__":
    np.random.seed(123456)
        
    Q = load(symbols)
    Qn = normalize(Q)
    Qr = returns(Qn)
    (rmean, rstd, rcov) = stats(Qr)
    print("rmean:", rmean)
    print("rstd:", rstd)
    print("rcov:", rcov)

    alpha = 0.05
    # X = np.random.rand(1,len(symbols))[0]
    X = (1.0/len(symbols)) * np.ones(len(symbols))
    print(X)
    f1 = np.sum(rmean * X)
    print(f1)
    f2 = np.dot(X, np.dot(X.T, rcov))
    print(f2)
    f3 = 1 - norm.ppf(alpha, 1 + f1, np.sqrt(f2))
    print(f3)
    f4 = (alpha**-1) * norm.pdf(norm.ppf(alpha)) * np.sqrt(f2) - f1
    print(f4)

    # R = Qr['aapl']
    # fig = plt.figure()
    # ax = fig.gca()
    # ax.hist(R[R.columns[-1]], bins=40)
    # ax.axvline(f3, color='r', linestyle='dashed', linewidth=1)
    # ax.axvline(f4, color='g', linestyle='dashed', linewidth=1)
    # plt.show()
