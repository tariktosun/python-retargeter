% Tarik Tosun, Princeton University
% Implements a roll-yaw-pitch shoulder, limb length len.
% Last Edited 4/13/12

function [DHfuncs, names, nl] = rpyShoulder(len)
    sroll = inline('[0, r, 0, 90]','r');          
    syaw = inline('[0, 90+y, 0, 90]','y');        
    spitch = inline(['[0, 180+p, ' num2str(len) ', 0]'],'p');     
    
    nl = [0 0 1];
    names = {'sroll','syaw','spitch'};
    DHfuncs = {sroll, syaw, spitch};
end

