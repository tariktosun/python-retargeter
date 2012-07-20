% olea.m, Tarik Tosun
% for chain3d class
% returns the chain in olea format.
function [origin,lengths,pyAngles] = olea(obj)
            [origin,lengths,pyAngles] = lep2olea3d(obj.endpoints);
end