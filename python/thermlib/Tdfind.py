"""The docstring for the Tdfind.py module."""

import numpy as np
from constants import constants

def Tdfind(wv, p):
    """
    Tdfind(wv, p)

    Calculates the due point temperature of an air parcel.

    Parameters
    - - - - - -
    wv : float
        Mixing ratio (kg/kg).
    p : float
        Pressure (Pa).

    Returns
    - - - -
    Td : float
        Dew point temperature (K).

    Examples
    - - - - -
    >>> Tdfind(0.001, 8.e4)
    253.39429263963504

    References
    - - - - - -
    Emanuel 4.4.14 p. 117
    
    """
    c = constants();    
    e = wv * p / (c.eps + wv);
    denom = (17.67 / np.log(e / 611.2)) - 1.;
    Td = 243.5 / denom;
    Td = Td + 273.15;
    return Td


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

