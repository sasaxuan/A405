import scipy.optimize

from findWvWl import findWvWl
from thetal import thetal

def tinvert(thetalVal, wT, p):
    """
    tinvert(thetalVal, wT, p)

    Determines the temperature corresponding to the specified liquid
    potential temperature.

    Parameters
    - - - - - -
    thetalVal : float
        Liquid potential temperature of the air parcel (K).        
    wT : float
        Total water mixing ratio (kg/kg),
    p : float
        Pressure (Pa).


    Returns
    - - - -
    T : float
        Temperature (K) corresponding to 'thetal'.
    wv : float
        Vapour mixing ratio (kg/kg) at 'p'.
    wl : float
        Liquid mixing ratio (kg/kg) at 'p'.


    Raises
    - - - -
    NameError
        If the value of 'p' is greater than 100000 Pa.


    Examples
    - - - - -
    >>> [T, wv, wl] = tinvert(300., 0.01, 8.e4)
    >>> T
    282.77595546332617
    >>> wv
    0.0094462286004982372
    >>> wl
    0.00055377139950176305
    >>> [T, wv, wl] = tinvert(300., 0.01, 8.e6)
    Traceback (most recent call last):
        ...
    NameError: expecting pressure level less than 100000 Pa
    
    """
    if p > 1.e5:
        raise NameError, \
              'expecting pressure level less than 100000 Pa'
    # The temperature has to be somewhere between 'thetal'
    # (T at surface) and -40 deg. C (no ice).
    
    T = scipy.optimize.zeros.brenth(Tchange, 233.15, thetalVal, \
                                     (thetalVal, wT, p));
    [wv, wl] = findWvWl(T, wT, p);
    return T, wv, wl


def Tchange(Tguess, thetalVal, wT, p):
    [wv, wl] = findWvWl(Tguess, wT, p);
    # Iterate on Tguess until this function is zero to within the
    # default tolerance in brenth.
    return thetalVal - thetal(Tguess, p, wv, wl);


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()

