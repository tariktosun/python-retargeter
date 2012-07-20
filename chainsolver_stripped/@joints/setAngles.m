%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   setAngles.m
%   Tarik Tosun, Princeton University / USC Interactions Lab, 9/8/11
% Description:
%   setAngles method for the joints object.  Sets the angles parameter of
%   the joints object, ensuring the value stays within the upper/lower
%   bounds.
% Usage:
%   myJoints = setAngles(myJoints, anglesVect);
%
% Last Edited:    4/12/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function obj = setAngles(obj, newAngles)
    BUFFER = 0.01;
    % Check size:
    if(size(newAngles,2)~=numDof(obj))
        error('newAngles vector is not the correct size');
    end
    % Check boundaries:
    if(~all(newAngles >= obj.Lbounds-BUFFER))
        error('Lower bound violation.');
    elseif(~all(newAngles <= obj.Ubounds+BUFFER))
        error('Upper bound violation.');
    end
    
    obj.angles = newAngles;
end