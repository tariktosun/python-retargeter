#forwardKinematics.py
# Tarik Tosun

import roslib
roslib.load_manifest('kdl')
from PyKDL import *

import pdb

def forwardKinematics(chain, angles):
    ''' returns the joint positions correspoinding to the given angles for the
    given chain. '''
    fk = ChainFkSolverPos_recursive(chain)
    frame = Frame()
    N = chain.getNrOfSegments() + 1
    positions = [0]*N
    for i in range(0,N):
        fk.JntToCart(angles,frame,i)
        pvect = frame.p
        positions[i] = [pvect.x(), pvect.y(), pvect.z()] 
    return positions
        
