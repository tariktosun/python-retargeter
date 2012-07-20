% gradient.m, Tarik Tosun
% for chainField3d class

% If the grad property is empty, gradient method computes the
% gradient of the field, and stores it as a cell array in the grad
% property.  The method then returns the grad property.

% Must always be called as follows:  [myChainField, gradient] = gradient(myChainField)

function [obj, gradient] = gradient(obj)
    if(isempty(obj.grad))
        [gx gy gz] = gradient(obj.potential);
        obj = chainField3d(obj,{gx gy gz});    %use grad adding constructor
    end
        gradient = obj.grad;
end