import numpy as np
from scipy.stats import norm
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
a= np.aray([1,2,3])
print type(a)
print a.shape
print a[0],a[1],a[2]
a[0]=5
print "......."
print norm.cdf(0)
x=np.arrange(0.3*np.pi,0.1)
y=np.sin(x)

plt.plot(x,y)
plt.savefig("plt_test.png")

print "\nDone"
 
