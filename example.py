# --------------------------------------------------------------------------- #
# example.py
# Tarik Tosun, 2012-07-19
# Description:
#     Demonstrates what you can do with python-retargeter.
# --------------------------------------------------------------------------- #

import numpy as np
import scipy as sp
from mlabwrap import mlab
# when mlabwrap is imported, it starts an instance of matlab which runs in the
# background.  Nearly any matlab function may be called as: 'mlab.[function]'


mlab.addpath(mlab.genpath('./minimal'))

# ----------------------------------------------------------- #
# Creating Kinematic Chain Models: 
# ----------------------------------------------------------- #

# pr2larm(length_total) returns a simulated PR2 left arm of specified total
# length. (pr2rarm returns a simulated PR2 right arm.)
# Degrees of freedom:
#     [shoulder_yaw, shoulder_tilt, shoulder_roll, elbow_flex]
L = 300
pr2 = mlab.pr2rarm(L)

# human24(lengths) returns a 2-link, 4-dof chain similar to a human arm.  the
# lengths vector specifies link lengths.
# Degrees of freedom:
#     [shoulder_roll, shoulder_yaw, shoulder_pitch, elbow_pitch]
#     note:  don't use the roll dof, it doesn't work (sorry!)
lengths = np.matrix([L/2, L/2])  # Note that we must use numpy data structures.
human = mlab.human24(lengths)

# ----------------------------------------------------------- #
# Manipulating and Visualizing Chains: 
# ----------------------------------------------------------- #

#  Manipulate chain pose with setJointAngles(chain, angles)
pr2_initial_angles = np.matrix([0,0,0,0])
pr2 = mlab.setJointAngles(pr2, pr2_initial_angles)

human_initial_angles = np.matrix([0,-110,40,-60])
human = mlab.setJointAngles(human, human_initial_angles)

#  Visualize chains with the draw() function.

mlab.figure()
mlab.grid('on')
mlab.headSphere() #creates a dummy head that provides context.

mlab.draw(pr2,'k')
mlab.draw(human)

# ----------------------------------------------------------- #
# Retargeting Chains: 
# ----------------------------------------------------------- #

# easy_retarget(source, target) abstracts away all the messy bits.
pr2_retargeted = mlab.easy_retarget(human, pr2)

# draw on the open figure:
mlab.draw(pr2_retargeted,'g')
mlab.title('Retargeting Demo')
mlab.legend('black - pr2 initial pose','blue - human source pose', 'green - pr2 retargeted pose')




