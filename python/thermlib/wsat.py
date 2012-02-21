"""This is the docstring for the wsat.py module. This module contains
two functions, wsat and replaceelem. Note that replaceelem is
designed for use within wsat.
"""

import scipy as sp

from constants import constants
from esat import esat

def wsat(Temp, press):
    """
    wsat(Temp, press)

    Calculates the saturation vapor mixing ratio of an air parcel.

    Parameters
    - - - - - -
    Temp : float or array_like
        Temperature in Kelvin.
    press : float or array_like
        Pressure in Pa.

    Returns
    - - - -
    theWs : float or array_like 
        Saturation water vapor mixing ratio in (kg/kg).

    Raises
    - - - -
    IOError
        If both 'Temp' and 'press' are array_like.

    Examples
    - - - - -
    >>> wsat(300, 8e4)
    0.028751159650442507
    >>> wsat([300,310], 8e4)
    [0.028751159650442507, 0.052579529573838296]
    >>> wsat(300, [8e4, 7e4])
    [0.028751159650442507, 0.033076887758679716]
    >>> wsat([300, 310], [8e4, 7e4])
    Traceback (most recent call last):
        ...
    IOError: Can't have two vector inputs.

    """
    c = constants();
    es = esat(Temp);

    # We need to test for all possible cases of (Temp,press)
    # combinations (ie. (vector,vector), (vector,scalar),
    # (scalar,vector), or (scalar,scalar).
    
    try:
        len(es)
    except:
        esIsVect = False
    else:
        esIsVect = True

    try:
        len(press)
    except:
        pressIsVect = False
    else:
        pressIsVect = True
    
    if esIsVect and pressIsVect:
        raise IOError, "Can't have two vector inputs."
    elif esIsVect:
        theWs = [(c.eps * i/ (press - i)) for i in es]
        # Limit ws values so rootfinder doesn't blow up.       
        theWs = list(replaceelem(theWs,0,0.060))
    elif pressIsVect:
        theWs = [(c.eps * es/ (i - es)) for i in press]
        # Limit ws values so rootfinder doesn't blow up.       
        theWs = list(replaceelem(theWs,0,0.060))
    else: # Neither 'es' nor 'press' in a vector.
        theWs = (c.eps * es/ (press - es))
        # Limit ws value so rootfinder doesn't blow up.
        if theWs > 0.060: theWs = 0.060
        elif theWs < 0: theWs = 0

    # Set minimum and maximum acceptable values for theWs.
        
    try:
        len(theWs)
    except:        
        if theWs > 0.060: theWs = 0.060
        elif theWs < 0: theWs = 0
    else:
        theWs = list(replaceelem(theWs, 0, 0.060))

    return theWs


def replaceelem(theList,lowLim,upLim):
    """
    raplaceelem(theList, lowLim, upLim)

    Replaces any elements in 'theList' greater than 'upLim' and less
    than 'lowLim' with the values of 'upLim' and 'lowLim',
    respectively.

    Parameters
    - - - - - -
    theList : array_like
        An array_like structure, the upper and lower bounds of which
        are to be tested.
    lowLim : int
        Number to replace any values within 'theList' that are lower
        than it.
    upLim : int
        Number to replace any values within 'theList' that are higher
        than it.

    Returns
    - - - -
    newList : array
        Augmentation of 'theList' with upper and lower bounds
        accounted for and replaced if necessary.
    """    
    newList = sp.zeros(len(theList))
    for i in theList:
        if i < lowLim:
            newList[theList.index(i)] = lowLim
        elif i > upLim:
            newList[theList.index(i)] = upLim
        else:
            newList[theList.index(i)] = i
    return newList


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
