"""This is the docstring for the LCLfind.py module."""

import numpy as np

from constants import constants
from esat import esat

def LCLfind(Td, T, p):
    """
    LCLfind(Td, T, p)

    Finds the temperature and pressure at the lifting condensation
    level (LCL) of an air parcel.

    Parameters
    - - - - - -
    Td : float
        Dewpoint temperature (K).
    T : float
        Temperature (K).
    p : float
        Pressure (Pa)

    Returns
    - - - -
    Tlcl : float
        Temperature at the LCL (K).
    plcl : float
        Pressure at the LCL (Pa).

    Raises
    - - - -
    NameError
        If the air is saturated at a given Td and T (ie. Td >= T)
    
    Examples
    - - - - -
    >>> [Tlcl, plcl] =  LCLfind(280., 300., 8.e4)
    >>> print [Tlcl, plcl]
    [275.76250387361404, 59518.928699453245]
    >>> LCLfind(300., 280., 8.e4)
    Traceback (most recent call last):
        ...
    NameError: parcel is saturated at this pressure

    References
    - - - - - -
    Emanuel 4.6.24 p. 130 and 4.6.22 p. 129
    
    """
    c = constants();

    hit = Td >= T;
    if hit is True:
        raise NameError('parcel is saturated at this pressure');

    e = esat(Td);
    ehPa = e * 0.01; #Bolton's formula requires hPa.
    # This is is an empircal fit from for LCL temp from Bolton, 1980 MWR.
    Tlcl = (2840. / (3.5 * np.log(T) - np.log(ehPa) - 4.805)) + 55.;

    r = c.eps * e / (p - e);
    #disp(sprintf('r=%0.5g',r'))
    cp = c.cpd + r * c.cpv;
    logplcl = np.log(p) + cp / (c.Rd * (1 + r / c.eps)) * \
              np.log(Tlcl / T);
    plcl = np.exp(logplcl);
    #disp(sprintf('plcl=%0.5g',plcl))

    return Tlcl, plcl


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
