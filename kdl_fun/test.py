# tests the retargeting solver functions.

import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import roslib
roslib.load_manifest('kdl')
from PyKDL import *
from functions import *

# Define source and target chains:
source = Chain()
sj0 = Joint(Joint.RotZ)
sf0 = Frame(Vector(0.361,0.0,0.0))
ss0 = Segment(sj0,sf0)
source.addSegment(ss0)
sj1 = sj0
sf1 = Frame(Vector(0.541,0.0,0.0))
ss1 = Segment(sj1,sf1)
source.addSegment(ss1)

target = Chain()
joint0 = Joint(Joint.RotZ)
frame0 = Frame(Vector(0.2,0.3,0))
segment0 = Segment(joint0,frame0)
target.addSegment(segment0)
joint1 = joint0
frame1 = Frame(Vector(0.4,0,0))
segment1 = Segment(joint1,frame1)
target.addSegment(segment1)
joint2 = joint1
frame2 = Frame(Vector(0.1,0.1,0))
segment2 = Segment(joint2,frame2)
target.addSegment(segment2)

# Test cost_joints_ee:
print "Testing cost_joints_ee:"
eps = [[0.0, 0.0, 0.0],
 [.361, 0.0, 0.0], 
 [.541, 0.0, 0.0]]

print cost_joints_ee([0,0,0], target, eps, 1)

# Test retarget:
print "Now testing retarget:"
source_angles = [0,-40*np.pi/180]
target_initial_angles = [0,0,0]
#target_bounds = [[-90, -90, -90],[90, 90, 90]]
target_bounds = [(-90,90),(-90,90),(-90,90)]
ret = retarget(source,source_angles,target,target_initial_angles,target_bounds)
ret_angles = ret[0].tolist()
print "Retargeted Angles:"
print ret_angles
ret_ep = forwardKinematics(target,ret_angles)
print "Retargeted Endpoints: "
print ret_ep

# Plot the results:
plt.ion()
fig = plt.figure()
ax = p3.Axes3D(fig)
draw(source, source_angles,ax,'b')
draw(target, target_initial_angles, ax, 'k')
draw(target, ret_angles, ax, 'r')
plt.show()
