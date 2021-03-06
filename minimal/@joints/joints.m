%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   joints.m
%   Tarik Tosun, Princeton University / USC Interaction Lab, 9/8/11
%   Last Edited: 4/11/12
% Description:
%   joints objects contain joint information for the chain3d class.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   joints class:
%   Properties:
%       names             - cell array of joint names (strings)
%       Ubounds           - upper bounds on joint angle values
%       Lbounds           - lower bounds on joint angle values
%       ForwardKinematics - Forward Kinematics specifier.
%       angles            - current values of the joint angles.
%   optional:
%       FKparams          - Struct  with params used to perform FK calculations.
%       newLimb           - binary array indicating whether joint defines a
%                           new limb.
%
%   ALL OF THESE PROPERTIES ARE INTENDED TO BE PRIVATE.  Please only change
%   these properties via the constructor and setAngles methods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constructor sets the names, upper/lower bounds, and forward kinematics
% properties for the joint object.  These properties are meant to be
% immutable for the lifetime of the object.  angles property is default set
% to the lower bounds.

function obj = joints(names,LB,UB,FKid,varargin)
    %%% Check arg validity %%%
    % size:
    if(~(all(size(UB)==size(LB))))
        error('upper, and lower bounds must be same size.');
    end
    % types:
    if(~iscell(names))
        error('names must be cell array of strings');
    % elseif(~type(FK)==FK_type)
    %   (yell at user);
    %maybe check ub/lb type here
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%     3D_DH     %%%
    
    if(strcmp(FKid, '3D_DH'))
        if(nargin~=6)
            error('3D_DH needs 6 args');
        end
        if(iscell(varargin{1}) && all(size(names)==size(varargin{1})))
            obj.FKparams = varargin{1};
        else
            error('Invalid or incorrectly sized FKparams');
        end
        if(all(size(LB)==size(varargin{2})))
            obj.newLimb = varargin{2};
        else
            error('incorrectly sized newLimb array.');
        end
    else
        obj.FKparams = {};
        obj.newLimb = [];
    end
    %%%%%%%%%%%%%%%%%%%%%%
    
    obj.names   = names;
    obj.Lbounds = LB;
    obj.Ubounds = UB;
    obj.ForwardKinematics = FKid;
    obj.angles  = LB;
    
    obj = class(obj, 'joints'); %make it a class rather than a struct.
end