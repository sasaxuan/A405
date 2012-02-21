"""This is the docstring for the L.py module.""" 

from constants import constants

def L(T):
    """
    L(T)

    Calculates the latent heat of vapourization for a given
    temperature 'T'.

    Parameters
    - - - - - -
    T : float
        Temperature (K).

    Returns
    - - - -
    theL : float
        Latent heat of vaporization (J/kg)

    Examples
    - - - - -
    >>> L(300.)
    2438708.0
    
    """
    c=constants();
    theL = c.lv0 + (c.cpv - c.cl) * (T - c.Tc);
    return theL

def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

