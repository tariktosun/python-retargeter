%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   motionImitation.m
%   Tarik Tosun, Princeton University
% Description:
%   Imitation function for the chainMotion class.  Returns a new
%   chainMotion with the source motion retargeted to the target chain.
% Usage:
%   retMotion = motionImitation(sourceMotion, targetChain,{makeImitation params});
%   {makeImitation_params} all get passed directly to chain3d.makeImitation.
%
% Created 3/19/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function retMotion = motionImitation(sourceMotion, targetChain,engine,scaleOpt,varargin)
    target = targetChain;    %  A buffer, so I don't touch the passed chain.
    source = sourceMotion.chain;
    if(strcmp(source.joints,'static_chain'))
        sEP = sourceMotion.epHist;
        static = 1;
    else
        sAngles = sourceMotion.angleHist;
        static = 0;
    end
    dof = numDof(targetChain);
    N = sourceMotion.numFrames;
    retAngles = zeros(N,dof);
    for i=1:N
        if(static==1)
            source = setEPstatic(source, sEP{i});
        else
            source = setJointAngles(source, sAngles(i,:));
        end
        [target,fitparams] = makeImitation(source,target,engine,scaleOpt,varargin{:});
        retAngles(i,:) = target.joints.angles();
    end
    retMotion = chainMotion(target,retAngles);
end

