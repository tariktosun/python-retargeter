#-----------------------------------------------------------------------------#
# retargeter.py
# Tarik Tosun 2012-08-06
# Retargeter class
#-----------------------------------------------------------------------------#
import numpy as np
import scipy as sp
from mlabwrap import mlab

mlab.addpath(mlab.genpath('./minimal'))

class Retargeter(object):
   ''' Retargeter Class '''
   def __init__(self, source_file, target_file):
      ''' Returns a retargeter based on definitions in the file arguments. '''
      self.source = build_chain(source_file)
      self.target = build_chain(target_file)

   def retarget(self,source_joint_angles):
      '''returns the retargeted target joint angles given the source joint
      angles. '''
      angles_matrix = np.matrix(source_joint_angles)
      self.source = mlab.setJointAngles(self.source, angles_matrix)
      self.target = mlab.easy_retarget(self.source, self.target) 
      return self.target.joints.angles

   def draw_chains(self):
      ''' Draws the source and target chain on the same axes, for debugging
      purposes. '''
      mlab.figure()
      mlab.grid('on')
      mlab.draw(self.source)
      mlab.draw(self.target, 'r')

def build_chain(chain_file):
   ''' builds and returns a matlab chain object according to the specifications
   in the file.'''
   f = open(chain_file, 'ro')
   lengths = eval(f.readline())
   lengths = np.matrix(lengths)
   chain =  mlab.easy_chain_builder(lengths)
   z = lengths*0  #zero matrix of same dimension as lengths 
   chain = mlab.setJointAngles(chain,z)
   return chain
   

      
      

           

  
