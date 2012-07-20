%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   numDof.m
%   Tarik Tosun, Princeton University / USC Interactions Lab, 4/11/12
% Description:
%   returns the number of degrees of freedom for the joints of a chain object.
%
% Last Edited:    4/11/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dof = numDof(obj)
    dof = numDof(obj.joints);
end

