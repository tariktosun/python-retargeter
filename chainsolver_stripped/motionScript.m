%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   motionScript.m
%   Tarik Tosun, Princeton University
% Description:
%   Tests / runs the chainMotion class.
%
% Created 3/19/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create chains:
s = chain3d([0 0 0],[1 1], {'foo','bar'}, [-120 -120], [120 120], '2D_simple');
s = setJointAngles(s, [-10 30]);
%d = setJointAngles(s, [50 50]);
d = chain3d([0 0 0],[2/3 2/3 2/3], {'foo','bar','baz'}, [-120 -120 -120], [120 120 120], '2D_simple');
d = setJointAngles(d, [0 50 50]);
%% Define source motion:
numFrames = 45;
t = [0:1:numFrames-1]';
traj = [45*sin(2*pi*(t/15)) 45*sin(2*pi*(t/15))]; 
waveMotion = chainMotion(s,traj);
%% make imitation motion:
retMotion = motionImitation(waveMotion,d,'simul_sqp_anon','scale',0.1);
%% run source animation:
figure;
view(3);
animate(waveMotion, [0 6 -3 5 -1 1]);
%% run imitation animation:
figure;
view(3);
animate(retMotion, [0 6 -3 5 -1 1]);