#!/usr/bin/env python

import numpy
from scipy import optimize

def find_interval(f, x, *args):
    x1 = x
    x2 = x
    if x == 0.:
        dx = 1./50.
    else:
        dx = x/50.
        
    maxiter = 40
    twosqrt = numpy.sqrt(2)
    a = x
    fa = f(a, *args)
    b = x
    fb = f(b, *args)
    
    for i in range(maxiter):
        dx = dx*twosqrt
        a = x - dx
        fa = f(a, *args)
        b = x + dx
        fb = f(b, *args)
        if (fa*fb < 0.): return (a, b)
        
    raise "Couldn't find a suitable range."

# This function evaluates a new point, sets the y range,
# and tests for convergence
def get_y(x, f, eps, ymax, ymin, *args):
    y = f(x, *args)
    ymax = max(ymax, y)
    ymin = min(ymin, y)
    converged = (abs(y) < eps*(ymax-ymin))
    return (y, ymax, ymin, converged)

def fzero(the_func, root_bracket, *args, **parms):
    # the_func is the function we wish to find the zeros of
    # root_bracket is an initial guess of the zero location.
    #   Can be a float or a sequence of two floats specifying a range
    # *args contains any other parameters needed for f
    # **parms can be eps (allowable error) or maxiter (max number of iterations.)
    answer=optimize.zeros.brenth(the_func,263,315,args=(e_target))
    return answer
    
def testfunc(x):
    return numpy.sin(x)
     
 
if __name__=="__main__":
    f = testfunc
    x = 1.
    print fzero(f, x)
    print fzero(f, x, eps=1e-300, maxiter = 80.)
