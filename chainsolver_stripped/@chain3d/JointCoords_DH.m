%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JointCoords_DH.m
% Tarik Tosun, Princeton University
% Created 4/12/12
% Description:
%   Function returning the joint coordinates of a kinematic chain given the
%   Denavit-Hartenberg matrices for its joints in their current state.
%   DH transformation matrices are passed in as a cell array of 4x3
%   matrices.  Returned joint coords vector has coordinates for N+1 joints,
%   where N is the number of transformation matrices (the first joint is
%   the base joint, [0 0 0]).
% Usage;
%   coords[x1,y1,z1;x2,y2,z2;...] = JointCoords_DH(DH_Mats{[1],[2],...});
%
% Last Edited: 4/12/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coords = JointCoords_DH(obj,angles,DHfuncs,newLimb)
    %check args
    %{
    if(~iscell(DH_Mats))
        error('DH_Mats must be a cell array.');
    end
    %}
    %%%
    
%    N = size(DH_Mats,2);
    N = numDof(obj);  
    coords = zeros(obj.numlinks+1,3);
    coords(1,:) = obj.origin;
    
    xform = eye(4,4);
    %perform initial orienting xform:
    f = DHfuncs{1};
    p = f(0);   % constant, arg meaningless
    T = dhMat(obj,p);
    xform = xform * T;
    c = xform * [0 0 0 1]';
    %coords(1,:) = c(1:3)';  %should just store origin.
    
    j = 2;  %coord # counter.
    if(~all(c(1:3)'==obj.origin))     %first joint offset from origin
        coords(2,:) = c(1:3)';
        j = j+1;
        %newLimb = [newLimb 1];
    end

    for i=1:N
        f = DHfuncs{i+1};
        p = f(angles(i));
        T = dhMat(obj,p);

        %generate xform matrix for this joint:
        xform = xform * T;
        c = xform * [0 0 0 1]';
        if(newLimb(i)==1)
            coords(j,:) = c(1:3)';
            j = j+1;
        end
    end
end