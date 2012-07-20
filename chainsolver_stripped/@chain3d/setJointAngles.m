%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   setJointAngles.m
%   Tarik Tosun, Princeton University / USC Interaction Lab, 9/12/11
% Description:
%   setJointAngles method for the chain3d object.  Calls the setAngles
%   method for the joints property of the chain, and then calls the FK
%   solver to update the chain endpoints.  If the chain had an associated
%   field, this field is cleared, as it is no longer valid.
% Usage:
%   myChain = setJointAngles(myChain, angleVect);
%
% Last Edited:  9/12/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function obj = setJointAngles(obj, newAngles)
    obj.joints    = setAngles(obj.joints, newAngles);
    obj.endpoints = forwardKinematics(obj);
    if(~isempty(obj.chainfield))
        obj.chainfield = [];
    end
    if(~isempty(obj.anonfield))
        obj.anonfield = [];
    end
end