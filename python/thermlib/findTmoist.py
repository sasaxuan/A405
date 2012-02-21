"""This is the docstring for the findTmoist.py module. This module
contains two functions: findTmoist and thetaEchange."""

from scipy import optimize 

from thetaes import thetaes

def findTmoist(thetaE0, press):
    """
    findTmoist(thetaE0, press)
    
    Calculates the temperatures along a moist adiabat.
    
    Parameters
    - - - - - -
    thetaE0 : float
        Initial equivalent potential temperature (K).
    press : float or array_like
        Pressure (Pa).

    Returns
    - - - -
    Temp : float or array_like
        Temperature (K) of thetaE0 adiabat at 'press'.

    Examples
    - - - - -
    >>> findTmoist(300., 8.e4)
    270.59590841970277
    
    """

    # First determine if press can be indexed
    try: len(press)
    except: #press is a single value
        Temp = optimize.zeros.brenth(thetaEchange, 200, 400, \
                                        (thetaE0, press));
    else: #press is a vector           
        Temp = []
        press = list(press)        
        for i in press:            
            # This assumes that the dewpoint is somewhere between 
            # 250K and 350K.
            Temp.append(optimize.zeros.brenth(thetaEchange, 200, \
                                                 400, (thetaE0, i)));
            #{'in Tmoist: ',i, result(i)}  
        
    return Temp
    

def thetaEchange(Tguess, thetaE0, press):
    """
    thetaEchange(Tguess, thetaE0, press)

    Evaluates the equation and passes it back to brenth.

    Parameters
    - - - - - -
    Tguess : float
        Trial temperature value (K).
    ws0 : float
        Initial saturated mixing ratio (kg/kg).
    press : float
        Pressure (Pa).

    Returns
    - - - -
    theDiff : float
        The difference between the values of 'thetaEguess' and
        'thetaE0'. This difference is then compared to the tolerance
        allowed by brenth.
        
    """
    thetaEguess = thetaes(Tguess, press);
    #{'in change: ',Tguess,press,thetaEguess,thetaE0}
    #when this result is small enough we're done
    theDiff = thetaEguess - thetaE0;
    return theDiff


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
