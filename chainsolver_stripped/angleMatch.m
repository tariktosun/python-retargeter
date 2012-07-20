%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% angleMatch.m
% Written by Tarik Tosun
% Description:
%   Performs (trivial) angle matching retargeting solution for source and
%   target chain.  Returns an error if they have different numbers of
%   joints.
%
% Created 1/6/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newChain, fitParams] = angleMatch(source, target, spacing)
   if(~all(size(source.joints.names)==size(target.joints.names)))
       error('Source and Target must have same number of joints for angleMatch engine.');
   end
   newChain = setJointAngles(target, source.joints.angles);
   
   
   % fitParams stuff: (mostly copied from simultaneous and sequential)
   numLinks = target.numlinks;
   lengths = target.lengths;
   if(spacing == 0)
        fitParams.num_int_points = numLinks;
    else
        n = 0;
        for i=1:numLinks
            n = n + size((spacing:spacing:lengths(i)),2);
        end
        fitParams.num_int_points = n;
    end
    fitParams.actual_fit = 0;     % No objective function for this solver.
    fitParams.perfect_fit = 1;
   
end