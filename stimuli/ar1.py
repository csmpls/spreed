from numpy import random as np
import sys

def AR1(n,x0,c,phi,sigma=1):   
    X = [x0]

    for i in range(n):
        X.append(c + phi * X[-1] + np.normal(scale=sigma))
    return X

def randWordFreq(baseline,std,n):
    return AR1(n,baseline,baseline/2,0.5,sigma=std)


baseline = float(sys.argv[1].split()[0])
print(randWordFreq(baseline,50,2000))