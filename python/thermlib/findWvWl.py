"""This is the docstring for the findWvWl.py module. This module
contains two functions: findWvWl and islist..
"""

import numpy as np

from wsat import wsat

def findWvWl(T, wT, p):
    """
    findWvWl(T, wT, p)

    Computes the vapour and liquid water mixing ratios.

    Parameters
    - - - - - -
    T : float
        Temperature (K).
    wT : float
        Total water mixing ratio (kg/kg).
    p : float
        Pressure (Pa).


    Returns
    - - - -
    wv : float
        Water vapour mixing ratio (kg/kg).
    wl : float
        Liquid water mixing ratio (kg/kg).


    Raises
    - - - -
    AssertionError
        If any of the inputs are in vector form.

    Examples
    - - - - -
    >>> findWvWl(250., 0.01, 8.e4)
    (0.00074331469136857157, 0.0092566853086314283)
    >>> findWvWl(300., 0.01, 8.e4)
    (0.01, 0)
    >>> findWvWl([250.], 0.01, 8.e4)
    Traceback (most recent call last):
        ...
    AssertionError: A vector is not an acceptable input
    
    """
    args = (T, wT, p);
    assert islist(*args) is False , \
           'A vector is not an acceptable input'
    
    wsVal = wsat(T, p);
    if wsVal > wT: #unsaturated
        wv = wT;
        wl = 0;
    else:  #saturated
        wv = wsVal;
        wl = wT - wv;
    return wv, wl


def islist(*args):
    """
    Takes any arguments and determines
    if any can be indexed (ie. are lists
    or arrays or tuples). If any are found to be
    indexable, then 'islist' returns 'True'.
    If none are indexable, then 'islist' returns
    'False'.
    """
    truelist = list(np.zeros(len(args)))
    args = list(args)

    count=0

    for i in args:
        try:
            i[0]
        except:
            truelist[count] = False
        else:
            truelist[count] = True
        count += 1
        
    if any(truelist):
        return True
    else:
        return False


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()


