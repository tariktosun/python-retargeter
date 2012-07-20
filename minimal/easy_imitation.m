%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% easy_imitation.m
% Tarik Tosun, 2012-07-12
% Description:
%    Makes chain imitations easy.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imitation] = easy_imitation(source, target)
   [imitation,params] = makeImitation(source, target, 'cost_joints_ee','scale',1)
end
