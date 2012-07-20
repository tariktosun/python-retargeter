%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ropt.m
% Tarik Tosun, Princeton University
% Description:
%   
% Created 3/20/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function r = ropt(obj,n,p,c,r,varargin)
    persistent foo;
    if(isempty(foo))
        foo = 1
    else
        foo = foo+1
    end
    % check bounds:
    if(n<1 || n>c.numKF)
        return;
    end
    
    [newJ newTA] = c.opt(obj,n,p,c,r,varargin{:});
    if(newJ > c.thresh*r.J(n))
        r.J(n) = newJ;
        r.tAngles(n,:) = newTA;
        r = ropt(obj,p,n,c,r,varargin{:});                  %parent
        if(p<n) r = ropt(obj,n+1,n,c,r,varargin{:}); ...   %other
        else r = ropt(obj, n-1,n,c,r,varargin{:}); end;
    end
    return;
end