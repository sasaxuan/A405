def tinvert_thetae(thetaeVal, wT, p):
    """
    tinvert_thetae(thetaeVal, wT, p)

    Uses a rootfinder to determine the temperature for which the
    pseudo equivilant potential temperature (thetaep) is equal to the
    equivilant potential temperature (thetae) of the parcel.

    Parameters
    - - - - - -
    thetaeVal : float
        Thetae of parcel (K).
    wtotal : float
        Total water mixing ratio (kg/kg).
    p : float
        Pressure of parcel in (Pa).

    Returns
    - - - -
    theTemp : float
        Temperature for which thetaep equals the parcel thetae (K).
    wv : float
        Vapor mixing ratio of the parcel (kg/kg).
    wl : float
        liquid water mixing ratio of the parcel (kg/kg) at 'p'.

    Raises
    - - - -
    IOError
        If 'p' is larger than 100000 Pa.

    Examples
    - - - - -
    >>> tinvert_thetae(300., 0.001, 8.e4)
    
    """
    import scipy.optimize
    
    if p > 1.e5:
        raise IOError('expecting pressure level less than 100000 Pa')
    # The temperature has to be somewhere between thetae
    # (T at surface) and -40 deg. C (no ice).    
    handle = Tchange
    theTemp = scipy.optimize.zeros.brenth(handle, 233.15, \
                                      thetaeVal, (thetaeVal, wT, p));
    [wv,wl] = findWvWl(theTemp, wT, p);
    return theTemp,wv,wl


def Tchange(Tguess, thetaeVal, wT, p):
    [wv, wl] = findWvWl(Tguess, wT, p);
    tdGuess = Tdfind(wv, p);
    # Iterate on Tguess until this function is
    # zero to within tolerance.
    return thetaeVal - thetaep(tdGuess, Tguess, p);

