"""This is the docstring for the thetaes.py module."""

import numpy as np

from constants import constants
from theta import theta
from wsat import wsat

def thetaes(T, p):
    """
    thetaes(T, p)

    Calculates the pseudo equivalent potential temperature of an air
    parcel.

    Parameters
    - - - - - -
    T : float
        Temperature (K).
    p : float
        Pressure (Pa).


    Returns
    - - - -
    thetaep : float
        Pseudo equivalent potential temperature (K).


    Notes
    - - -
    It should be noted that the pseudo equivalent potential
    temperature (thetaep) of an air parcel is not a conserved
    variable.


    References
    - - - - - -
    Emanuel 4.7.9 p. 132


    Examples
    - - - - -
    >>> thetaes(300., 8.e4)
    412.97362667593831
    
    """
    c = constants();
    # The parcel is saturated - prohibit supersaturation with Td > T.
    Tlcl = T;
    wv = wsat(T, p);
    thetaval = theta(T, p, wv);
    power = 0.2854 * (1 - 0.28 * wv);
    thetaep = thetaval * np.exp(wv * (1 + 0.81 * wv) * \
                                (3376. / Tlcl - 2.54))
    #
    # peg this at 450 so rootfinder won't blow up
    #
    if thetaep > 450.:
        thetaep = 450;

    return thetaep


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
