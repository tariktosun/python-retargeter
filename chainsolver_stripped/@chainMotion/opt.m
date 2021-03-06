%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% opt.m
% Tarik Tosun, Princeton University
% Description:
%   
% Created 3/21/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newJ, newAngles] = opt(obj,f,k,c,r,varargin)
    varargin = varargin{:};
    f
    k
    if(k>0) %if k=0 just use the current config (starting config).
        source = setJointAngles(c.source,c.sAngles(c.kf(f),:));
        target = setJointAngles(c.target,r.tAngles(k,:));
    else
        source = c.source;
        target = c.target;
    end
    
    [retarg, fp] = makeImitation(source,target,c.engine,c.scaleOpt,varargin{:});
    newJ = fp.actual_fit;
    newAngles = retarg.joints.angles;
   %figure; view([0 0]);
   draw(source,'r');
   draw(target,'k');
end

