import numpy as np
 
from L import L
from constants import constants

def thetal(T,p,wv,wl):
    """
    thetal(T,p,wv,wl)

    Calculates the liquid water potential temperature of a parcel.

    Parameters
    - - - - - -
    T : float
        Temperature (K).
    p : float
        Pressure (Pa)
    wv : float
        Vapour mixing ratio (kg/kg).
    wl : float
        Liquid water potential temperature (kg/kg).


    Returns
    - - - -
    thetalOut : float
        Liquid water potential temperature (K).


    References
    - - - - - -
    Emanuel 4.5.15 p. 121

    Examples
    - - - - -
    >>> thetal(300., 8.e4, 0.03, 0.01)
    298.21374486200278
    
    """
    c = constants();
    Lval = L(T);
    wt = wv + wl;
    chi = (c.Rd + wt * c.Rv) / (c.cpd + wt * c.cpv);
    gamma = wt * c.Rv / (c.cpd + wt * c.cpv);
    thetaVal = T * (c.p0 / p) ** chi;
    term1 = (1 - wl / (1. + wt)) * (1 - wl / (c.eps + wt)) ** (chi-1)
    term2 = (1 - wl / wt) ** (-1. * gamma);
    cp = c.cpd + wt * c.cpv;
    thetalOut = thetaVal * term1 * term2 \
                * np.exp(-1. * Lval * wl/(cp*T));

    return thetalOut


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

