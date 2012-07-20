%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 					OCTAVE VERSION
% chain3d.m  - OLD VERSION
% Tarik Tosun, USC Interaction Lab, 7/15/11
% Description:
%   Object representation of a robotic chain in three dimensions with
%   rotational freedom between limbs.

%Last edited 8/1/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% chain3d class:
% properties:
%	endpoints, numlinks, length, chainfield.
%	(please do not touch chainfield, it's supposed to be private).
% Methods:
%	

function obj = chain3d(varargin)
     %%% Constants %%%
     DEFAULT_LIMS = [-180 180 0 0];
     %%%%%%%%%%%%

     % Check for alternative constructors
     if(strcmp(class(varargin{1}),'chain3d'))
           if(nargin~=2)
                 error('Too many input arguments');
           end
           if(strcmp(class(varargin{2}),'chainField3d'))	%add chainfield
                 obj = struct(varargin{1});
                 obj.chainfield = varargin{2};
           end
           if(strcmp(class(varargin{2}),'function_handle'))	%add anonfield
                 obj = struct(varargin{1});
                 obj.anonfield = varargin{2};
           end
           
     else	%usual constructor - copied from MatLab code.
               if(or(nargin==1,nargin==2))  %LEP
                     if(size(varargin{1},2) ~= 3)
                          error('Incorrect LEP input dimensions');
                     end
                     obj.endpoints = varargin{1};
                     obj.numlinks = size(obj.endpoints,1)-1;
                    [origin lengths pyAngles] = lep2olea3d(obj.endpoints);
                    obj.length = sum(lengths);
                    obj.chainfield = [];	%OCTAVE EDIT
                    obj.anonfield = [];
                    if(nargin==1)   %no angle limits specified, use default.
                         obj.pyLimits = repmat(DEFAULT_LIMS,obj.numlinks,1);
                   else            %angle limits specified
                         if(all(size(varargin{2})==[obj.numlinks,4]))
                         obj.pyLimits = varargin{2};
                         checkLimits(obj,pyAngles); %make sure angles are within limits.		OCTAVE EDIT
                         else
                               error('Input dimension mismatch');
                         end
                   end
            elseif(or(nargin==3,nargin==4))  %OLeA
                    origin = varargin{1};
                    lengths = varargin{2};
                    pyAngles = varargin{3};
                   obj.endpoints = olea2lep3d(origin,lengths,pyAngles);
                   obj.numlinks = size(obj.endpoints,1)-1;
                   obj.length = sum(lengths);
                   obj.chainfield = [];		%OCTAVE EDIT
                   obj.anonfield = [];
                   if(nargin==3)   %no angle limits, use default
                          obj.pyLimits = repmat(DEFAULT_LIMS,obj.numlinks,1);
                  else
                         if(all(size(varargin{4})==[obj.numlinks,4]))
                                 obj.pyLimits = varargin{4};
                        else
                                error('Input dimension mismatch');
                        end
                  end
                  checkLimits(obj,pyAngles); %make sure angles are within limits.		OCTAVE EDIT
           else
                 error('Unexpected Inputs');
           end
     end
     obj = class(obj, 'chain3d'); 	%OCTAVE EDIT
end
      


