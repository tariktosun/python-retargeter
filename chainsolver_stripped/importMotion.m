%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% importMotion.m
% Tarik Tosun
%
% Description:
%   imports mocap data from infile (.oni), and saves chainMotions and pr2
%   arm chains to outfile (.m)
% Created 5/9/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function importMotion(infile,outfile)
    [Rmotion Lmotion] = bothArms3d(infile);
    close all;
    lR = sum(Rmotion.chain.lengths);
    lL = sum(Lmotion.chain.lengths);
    
    addpath('jointTypes/'); % to access pr2 arm creators
    Lpr2 = pr2larm(lL);
    Rpr2 = pr2rarm(lR);
    
    save(outfile);
end