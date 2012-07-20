% subsref.m, Tarik Tosun
% for chain3d class
% created 7/15/11

% Use builtin() assignment methods for all properties.
function value = subsref(obj, field)
    value = builtin('subsref', obj, field);
end