%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simpleIK.m
% Tarik Tosun
% Description:
%   Given a set of endpoints, returns the corresponding chain angles.
%   Works for the simple fk defined in forewardKinematcs.m as of 3/19/12.
%   Works for points in the x-z plane.  Basically a wrapper on lep2olea3d.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [o l angles] = simpleIK(endpoints)
    [o l a] = lep2olea3d(endpoints);
    a = a(:,1);
    as = circshift(a,1);
    as(1) = 0;
    angles = a - as;
end