%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					OCTAVE VERSION
% chainField3d.m
% Tarik Tosun, USC Interaction Lab, 7/5/11
% Description:
%   field objects for chains in three dimensions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% chainField3d class:
% Properties:
%	mesh, potential, grad.
%	(please don't touch grad, it's supposed to be private).



% public constructor takes a mesh cell array {x y z} and a potential 
% matrix and computes and stores them. gradient is not initialized
% in constructor.
function obj = chainField3d(varargin)
    if(nargin~=2)
        error('Unexpected Inputs');
    end
    if(strcmp(class(varargin{1}),'chainField3d'))    %constructor to add grad.
        if(~strcmp(class(varargin{2}),cell))
            error('Unexpected grad input');
        end
        obj = struct(varargin{1});
        obj.grad = varargin{2};
    else
        mesh = varargin{1};
        potential = varargin{2};
        %%% Argument Checking %%%
        s = size(mesh{1});
        if(size(mesh{2})~=s)
            error('mesh grid size mismatch');
       elseif(size(mesh{3})~=s)
            error('mesh grid size mismatch');
      elseif(size(potential)~=s)
           error('field-mesh grid size mismatch');
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%
      obj.mesh = mesh;
      obj.potential = potential;
      obj.grad = {};	%grad property  should be private , but b/c of octave OOP conventions, will remain accessible.  Please don't touch it.
   end
   obj = class(obj,'chainField3d');	
end