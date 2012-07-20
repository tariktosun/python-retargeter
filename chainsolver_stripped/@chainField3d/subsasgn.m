% subsasgn.m, Tarik Tosun
% for chainField3d3d class
% created 7/18/11

% Use builtin() assignment methods for all properties.
function obj = subsasgn(obj, field, value)
        obj = builtin('subsasgn', obj, field, value);
end