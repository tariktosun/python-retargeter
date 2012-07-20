%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dhMat.m
% Tarik Tosun, MAE 345, Princeton University
% Created 4/12/12
% Description:
%   Function returning the transformation matrix from the previous joint's
%   frame to the current joint's frame given the Denavit-Hartenberg
%   parameters t, l, a, and d.
% Usage;
%   transMat = DenHart([d, theta, l, alpha]);
%
% Last Edited: 4/12/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function transMat = dhMat(obj,params)
d = params(1);
theta = params(2);
l = params(3);
alpha = params(4);

t = toRadians(theta);
a = toRadians(alpha);
transMat = [cos(t)  -sin(t)*cos(a)  sin(t)*sin(a)   l*cos(t);
            sin(t)  cos(t)*cos(a)   -cos(t)*sin(a)  l*sin(t);
            0           sin(a)              cos(a)  d       ;
            0           0                       0   1        ];
end