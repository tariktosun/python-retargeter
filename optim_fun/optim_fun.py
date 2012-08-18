# fun with optimzation!
# And Tarik!
# 08/17/12

#I'm testing fmin_tnc here using a very simple quadratic function

from scipy.optimize import fmin_tnc

def objective(X):
    ''' objective function '''
    x = X[0]+5 
    y = X[1]
    return x*x + y*y

x0 = [1,1]
b = [(-4,4),(-10,10)]

res = fmin_tnc(objective, x0,approx_grad=1,bounds=b)
# returns something very near to [-4,0] as the minimum :-)



