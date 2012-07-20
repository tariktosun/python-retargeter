%%% YMCA script
% Tarik Tosun

%% export:
pr2_plain(a8_kLMotion_PR2_L_1.angleHist,'/home/tarik/tarik_retargeter/chainsolver/thesisdemo/ymcaL4.txt')
pr2_plain(a8_kRMotion_PR2_R_1.angleHist,'/home/tarik/tarik_retargeter/chainsolver/thesisdemo/ymcaR4.txt')

%% view results:
figure; view([0 90]); grid on; headSphere;
animate(a8_kLMotion_PR2_L_1, a8_kRMotion_PR2_R_1, kLMotion, kRMotion);

%% Import Kinect Data:
[kRMotion kLMotion]= bothArms3d('thesisdemo/ymca2.oni');
rChain = kRMotion.chain;
lChain = kLMotion.chain;

rChain = setEPstatic(rChain,kRMotion.epHist{1});
LR = sum(rChain.lengths);
origRMotion = kRMotion;

lChain = setEPstatic(lChain,kLMotion.epHist{1});
LL = sum(lChain.lengths);
origLMotion = kLMotion;

%% cut to size:
nf = 260;
kRMotion.numFrames = nf;
kRMotion.epHist = origRMotion.epHist(1:kRMotion.numFrames);

kLMotion.numFrames = nf;
kLMotion.epHist = origLMotion.epHist(1:kLMotion.numFrames);

%% test
figure; view([0 90]); grid on; headSphere;
xlabel('x'); ylabel('y'); zlabel('z'); axis equal
animate(kLMotion, kRMotion);

%% create PR2 chains:

PR2_L = pr2larm(LL);
PR2_R = pr2rarm(LR);

