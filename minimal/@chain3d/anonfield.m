% anonfield.m, Tarik Tosun
% for chain3d class
% created 8/1/11


% anonfield method returns an Anonymous Function Field (AFF) with
% the potential field for this chain.
function [anonField] = anonfield(obj,potential)
    if(isempty(obj.anonfield))
        anonfield = makeField3d_anon(obj,potential);	%OCTAVE EDIT
        obj = chain3d(obj,anonfield);		
    end
    anonField = obj.anonfield;
end