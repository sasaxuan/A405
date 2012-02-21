import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

from constants import constants
from convertSkewToTemp import convertSkewToTemp
from theta import theta
from wsat import wsat
from thetaes import thetaes
from convertTempToSkew import convertTempToSkew

def convecSkew(figNum):
      """       
      Usage:  convecSkew(figNum)
      Input:  figNum = integer
       Takes any integer, creates figure(figNum), and plots a
       skewT logp thermodiagram.
      Output: skew=30.
      """
      c = constants();
      plt.figure(figNum);
      plt.clf();
      yplot = range(1000,190,-10)
      xplot = range(-300,-139)
      pvals = np.size(yplot)
      tvals = np.size(xplot)
      temp = np.zeros([pvals, tvals]);
      theTheta = np.zeros([pvals, tvals]);
      ws = np.zeros([pvals, tvals]);
      theThetae = np.zeros([pvals, tvals]);      
      skew = 30; #skewness factor (deg C)

      # lay down a reference grid that labels xplot,yplot points 
      # in the new (skewT-lnP) coordinate system .
      # Each value of the temp matrix holds the actual (data)
      # temperature label (in deg C)  of the xplot, yplot coordinate.
      # pairs. The transformation is given by W&H 3.56, p. 78.  Note
      # that there is a sign difference, because rather than
      # taking y= -log(P) like W&H, I take y= +log(P) and
      # then reverse the y axis         
      
      for i in yplot:
            for j in xplot:
                  # Note that we don't have to transform the y
                  # coordinate, as it is still pressure.
                  iInd = yplot.index(i)
                  jInd = xplot.index(j)
                  temp[iInd, jInd] = convertSkewToTemp(j, i, skew);
                  Tk = c.Tc + temp[iInd, jInd];
                  pressPa = i * 100.;
                  theTheta[iInd, jInd] = theta(Tk, pressPa);
                  ws[iInd, jInd] = wsat(Tk, pressPa);
                  theThetae[iInd, jInd] = thetaes(Tk, pressPa);
                  
      #
      # Contour the temperature matrix.
      #

      # First, make sure that all plotted lines are solid.
      mpl.rcParams['contour.negative_linestyle'] = 'solid'
      tempLabels = range(-40, 50, 10);
      output1 = plt.contour(xplot, yplot, temp, tempLabels, \
                            colors='k')
      
      #
      # Customize the plot
      #
      
      plt.setp(plt.gca(), yscale='log')
      locs = np.array(range(100, 1100, 100))
      labels = locs
      plt.yticks(locs, labels) # Conventionally labels semilog graph.
      plt.setp(plt.gca(), ybound=(200, 1000))
      plt.setp(plt.getp(plt.gca(), 'xticklabels'), fontweight='bold')
      plt.setp(plt.getp(plt.gca(),'yticklabels'), fontweight='bold')
      plt.grid(True)
      plt.setp(plt.gca().get_xgridlines(), visible=False)
      plt.hold(True);
      
      thetaLabels = range(200, 380, 10);
      output2 = plt.contour(xplot, yplot, theTheta, thetaLabels, \
                        colors='b');

      wsLabels = range(6, 24, 2);
      output3 = plt.contour(xplot, yplot, (ws * 1.e3), wsLabels, \
                        colors='g');

      thetaeLabels = range(250, 380, 10);
      output4 = plt.contour(xplot, yplot, theThetae, thetaeLabels, \
                        colors='r'); 
      
      # Transform the temperature,dewpoint from data coords to
      # plotting coords.
      plt.title('skew T - lnp chart');
      plt.ylabel('pressure (hPa)');
      plt.xlabel('temperature (deg C)');

      #
      # Crop image to a more usable size
      #    
      
      TempTickLabels = range(5, 35, 5);
      TempTickCoords = TempTickLabels;
      skewTickCoords = convertTempToSkew(TempTickCoords, 1.e3, skew);
      plt.xticks(skewTickCoords, TempTickLabels)
      skewLimits = convertTempToSkew([5, 30], 1.e3, skew);
      plt.axis([skewLimits[0], skewLimits[1], 600, 1.e3]);
      
      #
      # Create line labels
      #

      fntsz = 9 # Handle for 'fontsize' of the line label.
      ovrlp = 1 # Handle for 'inline'. Any integer other than 0
                # creates a white space around the label.
                
      plt.clabel(output1, inline=ovrlp, fmt='%1d', fontsize=fntsz);
      plt.clabel(output2, inline=ovrlp, fmt='%1d', fontsize=fntsz);
      plt.clabel(output3, inline=ovrlp, fmt='%1d', fontsize=fntsz);
      plt.clabel(output4, inline=ovrlp, fmt='%1d', fontsize=fntsz);

      #
      # Flip the y axis
      #
      
      plt.setp(plt.gca(), ylim=plt.gca().get_ylim()[::-1])
      
      return skew
