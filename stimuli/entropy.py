import numpy as np
import sys

def pSpectrum(vector):
    
    A = np.fft.fft(vector)
    ps = np.abs(A)**2
    ps = ps[:len(ps)/2]
        
    return ps

def entropy(power_spectrum,q):
    q = float(q)
    
    power_spectrum = np.array(power_spectrum)
        
    if not q ==1:
        S = 1/(q-1)*(1-np.sum(power_spectrum**q))
    else:
        S = - np.sum(power_spectrum*np.log2(power_spectrum))
        
    return S

def entropyOnline(rawData,q=1):

    rawData = [float(x) for x in rawData]

    ps = np.array(pSpectrum(rawData))

    ps = ps/np.sum(ps)

    s = entropy(ps,q)

    return s

fresh_raws = sys.argv[1].split()
print(entropyOnline(fresh_raws,1))