%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   setEPstatic.m
%   Tarik Tosun, Princeton University 
% Description:
%   Sets the endpoints as specified for a static chain.
% Usage:
%   myChain = setEPstatic(myChain, newEP);
%
% Last Edited:  4/14/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function obj = setEPstatic(obj, newEP)
    if(strcmp(obj.joints,'static_chain'))   % check that chain is static
        % check that lengths don't change.
        %if(all(sqrt(sum(abs(newEP(2:end,:)).^2,2))' == obj.lengths))
            obj.endpoints = newEP;
        %{
        else
            error('new endpoints would cause limb lengths to change');
        end
            %}
    else
        error('setEPstatic valid only for static chains');
    end
end

