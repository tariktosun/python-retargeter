% field.m, Tarik Tosun
% for chain3d class.


% field method returns a chainField3d object with a potential field
% for this chain. res is [xres yres zres] specifying desired field
% resolution.  To reaccess field, call without res.

% Must always be called as follows: [mychain,chainField] = field(mychain)

      
function [obj,chainField] = field(obj,varargin)
    switch(nargin)
        case 1      %no resolution specified
            if(isempty(obj.chainfield))
                error('field uninitialized, please specify res');
            end
        case 2      %resolution specified
            res = varargin{1};
            field = makeField3d(obj,res);
            obj = chain3d(obj,field);	%use field-adding constructor.
        otherwise
            error('Unexpected inputs');
    end
    chainField = obj.chainfield;
end