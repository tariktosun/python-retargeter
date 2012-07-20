% subsref.m, Tarik Tosun
% for chainMotion class
% created 3/19/12
function value = subsref(obj, field)
    % use builtin() assignment methods for all properties.
    value = builtin('subsref', obj, field);
end

