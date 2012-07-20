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
%% explore lengths:
load('epData.mat');
N = size(epHist,2);
L = zeros(N,3);
for i=1:N;
    newEP = epHist{i};
    L(i,:) = sqrt(sum(abs(newEP(2:end,:)).^2,2))';
end
figure; plot(L);
%% Import Kinect data:
kMotion = rightArm3d('thesisdemo/shake0.oni');
%load('epData.mat');
%ep = epHist{1};
%chain = chain3d(ep,'static_chain');
%kMotion = chainMotion(chain,epHist);
kChain = kMotion.chain;
Chain = setEPstatic(kChain,kMotion.epHist{1});
L = sum(kChain.lengths);
origMotion = kMotion;
%% cut to size:
kMotion.numFrames = 180;
kMotion.epHist = origMotion.epHist(1:kMotion.numFrames);
%% test
figure; view([0 90]); grid on; headSphere;
xlabel('x'); ylabel('y'); zlabel('z'); axis equal
animate(kMotion);
%% get rid of stuff for commit
clear Chain L kMotion kChain origMotion
%% make imitation with emulated human arm:
addpath('jointTypes/');
length = sum(kChain.lengths);
harm = human24([length/2, length/2]);
harm = setJointAngles(harm, [0 0 0 0]);
%%
ret = motionImitation(kMotion, harm, 'cost_joints_ee','noscale',0.5);
%%
figure; view([0 90]); grid on; headSphere;
view([0 90]); animate(wave1, a_wave1_PR2_wave1_1);
%%
figure; view([0 90]); grid on; headSphere;
xlabel('x'); ylabel('y'); zlabel('z'); axis equal
p8 = setJointAngles(p8, [90 0 0 0]);
draw(p8);

%%
clear; save('cloud/fromcloud.mat'); save('cloud/fromlocal.mat');
