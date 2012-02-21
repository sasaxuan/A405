#!/usr/bin/env python

import numpy
import rootfinder
import scipy.optimize
from numpy import array

# Definition of thermodynamic constant:
cp = 1004.    # Heat capacity at constant pressure for dry air [J kg^-1 K^-1]
cpv = 1870.    # Heat capacity at constant pressure of water vapor [J kg^-1 K^-1]
Cl = 4190.     # Heat capacity of liquid water [J kg^-1 K^-1]
Rv = 461.      # Gas constant of water vapor [J kg^-1 K^-1]
Rd = 287.      # Gas constant of dry air [J kg^-1 K^-1]
Lv = 2.50104e6 # Latent heat of vaporization [J kg^-1]
Lf = 0.3336e6  # Latent heat of fusion [J kg^-1]
Ls = 2.8440e6  # Latent heat of sublimation [J kg^-1]
g = 9.81       # Accelleration of gravity [m s^-2]
p_0 = 100000.
epsilon = Rd/Rv
lam = Rv/Rd - 1.

tbgmin = 253.16
tbgmax = 273.16
tprmin = 268.16
tprmax = 283.16
tgrmin = 223.16
tgrmax = 283.16

an = 1./(tbgmax - tbgmin)
bn = tbgmin * an
ap = 1./(tprmax - tprmin)
bp = tprmin * ap

fac_cond = Lv/cp
fac_fus = Lf/cp
fac_sub = Ls/cp

fac1 = fac_cond + (1 + bp)*fac_fus
fac2 = fac_fus*ap
ag = 1./(tgrmax - tgrmin)

def find_chi_orig(T, Te, qv, qve, qn, p):

    chi = 0.2
    frac = 0.15
    delta = 0.61
    
    r = qv
    rl = qn
    re = qve

    qt_env = qve
    qvenv = qve
    ql_core = qn
    qt_core = qn+qv
    tenv = Te
    pres = p
    tucore = T

    exner = T/theta(pres, T)    
    thtl_core = theta_l(p, T, qn, 0.)
    thtl_env = theta_l(p, Te, 0., 0.)

    thv_core = theta_v(p, T, r, rl)
    thv_env = theta_v(p, Te, re, 0.)
                  
    esatucore = 610.78 * numpy.exp(17.2694 * (tucore - 273.16) / (tucore - 35.86))
    qsatucore = 0.622 * esatucore/(pres - esatucore)
    dqsdtucore = (0.622 * Lv * qsatucore)/(Rd * tucore * tucore)
    
    gammacore = (Lv/cp) * dqsdtucore
    funccore = (1. / (1. + gammacore)) * ((qt_env - qt_core) - exner * dqsdtucore * (thtl_env - thtl_core))
    
    chicritcore = (thv_env - thv_core) / \
                      (thtl_core*(delta*(qt_env - qt_core) - (1. + delta)*funccore) + \
                                      (thtl_env - thtl_core)*(1. + delta*qt_core - (1. + delta)*ql_core) + (Lv/(exner*cp))*funccore)

#    print numpy.mean(gammacore), numpy.mean(delta), numpy.mean(funccore)
                                      
    return chicritcore

def find_chi(T, T_env, qv, qv_env, qn, qp, qp_env, p):

    A = T/theta(p, T)

    thetal = theta(p, T) - Lv*q_to_specific_humidity(qn)/cp/A
    thetal_env = theta(p, T_env)
    del_thetal = thetal - thetal_env

    alpha = cp/Lv*A*thetal
    
    del thetal, thetal_env

    thetav = theta_v(p, T, qv, qn, qp)
    thetav_env = theta_v(p, T_env, qv_env, 0., qp_env)
    del_thetav = thetav - thetav_env

    del thetav, thetav_env

    del_qt = q_to_specific_humidity(qv) + q_to_specific_humidity(qn) + \
             q_to_specific_humidity(qp) - q_to_specific_humidity(qv_env) - \
             q_to_specific_humidity(qp_env)

    gamma = (Lv/cp)*dtqsatw(T, p)
    delta = (1 - epsilon)/epsilon
    beta = 1./(1. + gamma)*(1. + (1. + delta)*gamma*alpha)
    
    chi = del_thetav/(beta*del_thetal + (beta - alpha)*Lv/(cp*A)*del_qt)

    return chi
    
def q_to_specific_humidity(q):
    return q/(1. + q)
    
def h(T, z, qn, qi):
    return cp*T + g*z - Lv*qn - Ls*qi

def T_v(T, qv, qn, qp):
    return T*(1. + lam*qv - qn - qp)

def rho(p, T, qv, qn, qp):
    Tv = T_v(T, qv, qn, qp)
    return p/Rd/Tv

def theta(p, T): return T*(p_0/p)**(Rd/cp)

def theta_v(p, T, qv, qn, qp):
    return theta(p, T_v(T, qv, qn, qp))
    
def theta_l(p, T, qn, qp):
    return theta(p, T) - Lv/cp*(qn + qp)

def invert_h(h, z, p, q, qp):
    Tabs = (h - g*z)/cp
    qp = qp + 0.*Tabs
    Tabs1 = (Tabs + fac1*qp)/(1. + fac2*qp)

    T_gt = Tabs1 >= tbgmax
    T_lt = Tabs1 <= tbgmin

    Tabs1[T_gt] = Tabs[T_gt] + fac_cond*qp[T_gt]
    Tabs1[T_lt] = Tabs[T_lt] + fac_sub*qp[T_lt]

    om = an*Tabs1 - bn
    om[T_gt] = 1.
    om[T_lt] = 0.

    qsatt = om*qsatw(Tabs1, p) + (1.-om)*qsati(Tabs1, p)

    niter = 0
    dTabs = 100. + 0.*Tabs
    qn = q-qsatt

    while (niter < 10):
        T_gt = Tabs1 >= tbgmax
        T_lt = Tabs1 <= tbgmin

        om = an*Tabs1 - bn
        om[T_gt] = 1.
        om[T_lt] = 0.

        dlstarn = an*fac_fus + Tabs1*0.
        dlstarn[T_gt] = 0.
        dlstarn[T_lt] = 0.

        lstarn = om*fac_cond + (1.-om)*fac_sub

        qsatt = om*qsatw(Tabs1, p) + (1.-om)*qsati(Tabs1, p)
        dqsat = om*dtqsatw(Tabs1, p) + (1.-om)*dtqsati(Tabs1, p)

        T_gt = Tabs1 >= tprmax
        T_lt = Tabs1 <= tprmin

        omp = ap*Tabs1 - bp
        omp[T_gt] = 1.
        omp[T_lt] = 0.
       
        lstarp = omp*fac_cond + (1. - omp)*fac_sub

        dlstarp = ap*fac_fus + 0.*Tabs1
        dlstarp[T_gt] = 0.
        dlstarp[T_lt] = 0.

        fff = Tabs - Tabs1 + lstarn*(q-qsatt) + lstarp*qp
        dfff = dlstarn*(q-qsatt) + dlstarp*qp - lstarn*dqsat - 1.
        dTabs = -fff/dfff
        
        niter = niter + 1
        Tabs1[qn > 0] = Tabs1[qn > 0] + dTabs[qn > 0]

    qsatt[qn > 0] = qsatt[qn > 0] + dqsat[qn > 0] * dTabs[qn > 0]
    qn[qn > 0] = (q-qsatt)[qn > 0]
    qn[qn < 0] = 0.

    return Tabs1, qn

def esatw(T):
    # Saturation vapor [Pa]
    a = (6.11239921, 0.443987641, 0.142986287e-1, 0.264847430e-3, 0.302950461e-5,
         0.206739458e-7, 0.640689451e-10, -0.952447341e-13, -0.976195544e-15)
    dT = T-273.16
    dT[dT<-80.] = -80.
    return (a[0] + dT*(a[1] + dT*(a[2] + dT*(a[3] + dT*(a[4] + dT*(a[5] + dT*(a[6] + dT*(a[7] + dT*a[8]))))))))*100.
    
def qsatw(T, p):
    esat = esatw(T)
    p_esat = p - esat
    p_esat[esat > p_esat] = esat[esat > p_esat]
    return 0.622 * esat/p_esat

def dtesatw(T):
    a = (0.443956472, 0.285976452e-1, 0.794747212e-3, 0.121167162e-4, 0.103167413e-6,
         0.385208005e-9, -0.604119582e-12, -0.792933209e-14, -0.599634321e-17)
    dT = T-273.16
    dT[dT<-80.] = -80.
    return (a[0] + dT*(a[1] + dT*(a[2] + dT*(a[3] + dT*(a[4] + dT*(a[5] + dT*(a[6] + dT*(a[7] + dT*a[8]))))))))*100.

def dtqsatw(T, p):
    return 0.622*dtesatw(T)/p

def esati(T):
    a = (6.11147274, 0.503160820, 0.188439774e-1, 0.420895665e-3, 0.615021634e-5,
         0.602588177e-7, 0.385852041e-9, 0.146898966e-11, 0.252751365e-14)
    dT = T-273.16
    answer = a[0] + dT*(a[1] + dT*(a[2] + dT*(a[3] + dT*(a[4] + dT*(a[5] + dT*(a[6] + dT*(a[7] + dT*a[8])))))))
    dT[dT<-100.] = -100.
    answer[dT < -88.16] = 0.00763685 + dT[dT < -88.16]*(0.000151069 + dT[dT < -88.16]*7.48215e-7)
    return answer*100.

def qsati(T, p):
    esat = esati(T)
    p_esat = p - esat
    p_esat[esat > p_esat] = esat[esat > p_esat]
    return 0.622 * esat/p_esat
        
def dtesati(T):
    a = (0.503223089, 0.377174432e-1, 0.126710138e-2, 0.249065913e-4, 0.312668753e-6,
         0.255653718e-8, 0.132073448e-10, 0.390204672e-13, 0.497275778e-16)
    dT = T-273.16
    answer = a[0] + dT*(a[1] + dT*(a[2] + dT*(a[3] + dT*(a[4] + dT*(a[5] + dT*(a[6] + dT*(a[7] + dT*a[8])))))))
    dT[dT<-100.] = -100.
    answer[dT < -88.16] = 0.0013186 + dT[dT < -88.16]*(2.60269e-5 + dT[dT < -88.16]*1.28676e-7)
    return answer*100.

def dtqsati(T, p):
    return 0.622*dtesati(T)/p
    
def main():
    print find_chi(array([290., 290.]),
                   array([289., 289.]),
                   qsatw(array([290., 290.]), array([1e5,1e5])),
                   array([.008,.008]),
                   array([.001,.001]),
                   array([1e5, 1e5]))

if __name__ == '__main__':
    main()
