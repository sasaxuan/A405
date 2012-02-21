"""This is the docstring for the esat .py module"""

import numpy as np

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

    try: len(T) # determine if T has been input as a vector
    except: # if T is just a single value
        Tc = T-273.15
        esatOut = 611.2 * np.exp(17.67 * Tc / (Tc + 243.5)); 
    else: # if T is a vector
        Tc = [(i - 273.15) for i in T]
        esatOut = [(611.2 * np.exp(17.67 * i / (i + 243.5))) \
                   for i in Tc]
        if len(esatOut) == 1:
            esatOut = esatOut[0]
    return esatOut

    
def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
