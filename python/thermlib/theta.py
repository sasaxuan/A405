"""This is the docstring for the theta.py module."""

from constants import constants

def theta(*args):
    """
    theta(*args)

    Computes potential temperature.
    Allows for either T,p or T,p,wv as inputs.
    

    Parameters
    - - - - - -
    T : float
        Temperature (K).
    p : float
        Pressure (Pa).


    Returns
    - - - -
    thetaOut : float
        Potential temperature (K).


    Other Parameters
    - - - - - - - - -
    wv : float, optional
        Vapour mixing ratio (kg,kg). Can be appended as an argument
        in order to increase precision of returned 'theta' value.
    
    
    Raises
    - - - -
    NameError
        If an incorrect number of arguments is provided.
    
    
    References
    - - - - - -
    Emanuel p. 111 4.2.11


    Examples
    - - - - -
    >>> theta(300., 8.e4) # Only 'T' and 'p' are input.
    319.72798180767984
    >>> theta(300., 8.e4, 0.001) # 'T', 'p', and 'wv' all input.
    319.72309475657323
    
    """
    c = constants();
    if len(args) == 2:
        wv = 0;
    elif len(args) == 3:
        wv = args[2];
    else:
        raise NameError('need either T,p or T,p,wv');
    
    T = args[0];
    p = args[1];
    power = c.Rd / c.cpd * (1. - 0.24 * wv);
    thetaOut = T * (c.p0 / p) ** power;
    return thetaOut


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
