%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   kinectScript.m
%   Tarik Tosun, Princeton University
% Description:
%   Imports kinect data, stores to a chainMotion object, retargets to
%   another chain, and shows both animations.
%
% Created 3/20/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% clear
clear all; close all; clc
%% Import Kinect data:
kMotion = rightArm('demo/slowdemo.oni');
kChain = kMotion.chain;
kChain = setJointAngles(kChain,kMotion.angleHist(1,:));
L = sum(kChain.lengths);
origMotion = kMotion;
%% cut to size:
kMotion.numFrames = 200;
kMotion.angleHist = origMotion.angleHist(1:kMotion.numFrames,:);
%% 2dof imitation:
c2 = chain3d([0 0 0],[L/2 L/2], {'foo','bar'}, [-120 -120], [120 120], '2D_simple');
c2 = setJointAngles(c2, [0 -90]);
retMotion24 = motionImitation(kMotion,c2,'objective_global_eef','scale',0.1,25);
%% 3dof imitation:
d = chain3d([0 0 0],[331/3 331/3 331/3], {'foo','bar','baz'}, [-120 -120 -120], [120 120 120], '2D_simple');
d = setJointAngles(d, [0 45 45]);
retMotion3 = motionImitation(kMotion,d,'objective_global_eef','scale',0.1,500);
%% self imitation:
selfMotion = roptImitation(kMotion, kChain,10,1, 'objective_global_eef','scale',0.1,100);
%%
clc;
close all;
retMropt2 = roptImitation(kMotion,kChain,10,'objective_global_eef','scale',0.1,100);
%% 2dot ropt imitation:
c2 = chain3d([0 0 0],[L/2 L/2], {'foo','bar'}, [-120 -120], [120 120], '2D_simple');
c2 = setJointAngles(c2, [0 -90]);
clc;

retMropt2 = roptImitation(kMotion,c2,20,1,'objective_global_eef','scale',0.1,25);
%% 2dof joint based imitation:
c2 = chain3d([0 0 0],[L/2 L/2], {'foo','bar'}, [-120 -120], [120 120], '2D_simple');
c2 = setJointAngles(c2, [0 -90]);
clc;

jretMotion = motionImitation(kMotion,c2,'cost_joints_ee','scale',1);
%% 3dof joint based imitation:
c3 = chain3d([0 0 0],[L/3 L/3 L/3], {'foo','bar','baz'}, [-120 -120 -120], [120 120 120], '2D_simple');
c3 = setJointAngles(c3, [0 -45 -45]);
clc;

jretMotion3 = motionImitation(kMotion,c3,'cost_joints_ee','scale',0.5);
%% run imitation animation;
figure; view([180 180]);
%animate(kMotion, cne200_120);
%animate(kMotion, c200_120, c200_140, c200_170, c200_200);
%animate(kMotion, c200_140);
%animate(kMotion, jnewEE_d3e1, jtest_d3e1, jincEE_d3e1);
animate(kMotion, ross_d6e2, 'demo/5dof.avi');
%animate(kMotion, retMotion24);
%animate(kMotion, c50, c60, c70,c80);