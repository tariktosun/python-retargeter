% subsref.m, Tarik Tosun
% for chainField3d class
% created 7/18/11

% Use builtin() assignment methods for all properties.
function value = subsref(obj, field)
    value = builtin('subsref', obj, field);
end