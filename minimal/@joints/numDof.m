%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   numDof.m
%   Tarik Tosun, Princeton University / USC Interactions Lab, 4/11/12
% Description:
%   returns the number of degrees of freedom for a joints object.
%
% Last Edited:    4/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dof = numDof(obj)
    angles = obj.angles;
    dof = size(angles,2);
end

