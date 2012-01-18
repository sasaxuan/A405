"""This is the docstring for the esat.py module."""

import numpy as np
import matplotlib.cbook as cbook


def esat(T):
    """
    esat(T)

    Calculates the saturation water vapor pressure over a flat
    surface of water at temperature 'T'.

    Parameters
    - - - - - -
    T : float or array_like
        Temperature of parcel (K).

    Returns
    - - - -
    esatOut : float or list
        Saturation water vapour pressure (Pa).

    Examples
    - - - - -
    >>> esat(300.)
    3534.5196668891358
    >>> esat([300., 310.])
    [3534.5196668891358, 6235.5321818976754]

    References
    - - - - - -
    Emanuel 4.4.14 p. 117
      
    """
    # determine if T has been input as a vector
    is_scalar=True
    if cbook.iterable(T):
        is_scalar = False
    T=np.atleast_1d(T)
    Tc = T - 273.15
    esatOut = 611.2 * np.exp(17.67 * Tc / (Tc + 243.5))
    # if T is a vector
    if is_scalar:
        esatOut = esatOut[0]
    return esatOut

    
def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
