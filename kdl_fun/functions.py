# functions.py
# Tarik Tosun

import roslib
roslib.load_manifest('kdl')
from PyKDL import *
import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
from scipy.optimize import fmin_tnc

import pdb

def forwardKinematics(chain, angles):
    ''' returns the joint positions correspoinding to the given angles for the
    given chain. '''
    angles_JntArray= JntArray(len(angles))
    for i,a in enumerate(angles):
        angles_JntArray[i] = angles[i]

    fk = ChainFkSolverPos_recursive(chain)
    frame = Frame()
    N = chain.getNrOfSegments() + 1
    positions = [0]*N
    for i in range(0,N):
        fk.JntToCart(angles_JntArray,frame,i)
        pvect = frame.p
        positions[i] = [pvect.x(), pvect.y(), pvect.z()] 
    return positions


def draw(chain, angles, ax, plt_opts=""):
   ''' Draws the KDL chain passed in. Angles are the specified chain angles.  ax
   is an instance of p3.Axes3D.  plt_opts are plot options passed directly in.'''
   ep = forwardKinematics(chain,angles)
   ep = np.array(ep)
   #ax = p3.Axes3D(figure)
   x = ep[:,0]
   y = ep[:,1]
   z = ep[:,2]
   ax.plot(x,y,z,plt_opts)       

def retarget(source, source_angles, target, target_initial_angles, target_bounds):
    ''' 
    uses source_angles to set position of source chain, then returns
    retargeted angles for target chain.
    source: a KDL chain object
    source_angles: list of angles: [theta0, theta1,...thetaN]
    target & target_initial_angles similar
    target_bounds: list of bounds in the form: [(l1,u1),(l2,u2),...(lN,uN)]
    '''

    EE_ratio = 1
    eps = forwardKinematics(source,source_angles)
    objective = lambda angles: cost_joints_ee(angles, target, eps, EE_ratio)
    res = fmin_tnc(objective, target_initial_angles, approx_grad=1, bounds=target_bounds)
    return res

def cost_joints_ee(angles, target, eps, EE_ratio):
    ''' joint-total-distance cost function, implemented in python, '''
    Nt = target.getNrOfSegments()
    Ns = len(eps)-1
    ept = forwardKinematics(target,angles)
    eps = np.array(eps)
    ept = np.array(ept)
    # end effector term:
    s_ee = eps[-1,:]
    t_ee = ept[-1,:]
    rEE = np.abs(np.linalg.norm(s_ee - t_ee))
    # interior joint term:
    rJoints = 0
    for i in range(1,Nt):
        t = ept[i,:]
        for j in range(1,Ns):
            s = eps[j,:]
            rJoints += np.abs(np.linalg.norm(s-t))

    # normalize for number of source interior joints, multiply by ratio:
    m = Ns-1 # if EEratio = 1, EE counts as much as any other joint
    cost = rEE*m*EE_ratio + rJoints
    return cost



