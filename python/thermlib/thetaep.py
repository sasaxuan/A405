"""This is the docstring for the thetaep.py module."""

import numpy as np

from constants import constants
from LCLfind import LCLfind
from wsat import wsat
from theta import theta

def thetaep(Td, T, p):
    """
    thetaep(Td, T, p)

    Calculates the pseudo equivalent potential temperature of a
    parcel. 


    Parameters
    - - - - - -
    Td : float
        Dewpoint temperature (K).
    T : float
        Temperature (K).
    p : float
        Pressure (Pa).


    Returns
    - - - -
    thetaepOut : float
        Pseudo equivalent potential temperature (K).


    Notes
    - - -
    Note that the pseudo equivalent potential temperature of an air
    parcel is not a conserved variable.


    References
    - - - - - -
    Emanuel 4.7.9 p. 132


    Examples
    - - - - -
    >>> thetaep(280., 300., 8.e4) # Parcel is unsaturated.
    344.99830738253371
    >>> thetaep(300., 280., 8.e4) # Parcel is saturated.
    321.5302927767795
    
    """
    c = constants();
    if Td < T:
        #parcel is unsaturated
        [Tlcl, plcl] = LCLfind(Td, T, p);
        wv = wsat(Td, p);
    else:
        #parcel is saturated -- prohibit supersaturation with Td > T
        Tlcl = T;
        wv = wsat(T, p);
    
    # $$$   disp('inside theate')
    # $$$   [Td,T,wv]
    thetaval = theta(T, p, wv);
    power = 0.2854 * (1 - 0.28 * wv);
    thetaep = thetaval * np.exp(wv * (1 + 0.81 * wv) \
                                   * (3376. / Tlcl - 2.54));
    #
    # peg this at 450 so rootfinder won't blow up
    #
    if(thetaepOut > 450.):
        thetaepOut = 450;
    return thetaepOut


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

