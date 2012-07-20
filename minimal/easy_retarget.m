%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% easy_retarget.m
% Tarik Tosun, 2012-07-12
% Description:
%    Makes chain retargeting easy.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imitation] = easy_retarget(source, target)
   [imitation,params] = makeImitation(source, target, 'cost_joints_ee','noscale',5);
end
