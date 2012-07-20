% subsref.m, Tarik Tosun
% for joints class9/8/11
% created 

% Use builtin() assignment methods for all properties.
function value = subsref(obj, field)
    value = builtin('subsref', obj, field);
end