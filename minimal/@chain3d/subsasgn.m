% subsasgn.m, Tarik Tosun
% for chain3d class
% created 7/15/11

% Use builtin() assignment methods for all properties.
function obj = subsasgn(obj, field, value)
        obj = builtin('subsasgn', obj, field, value);
end