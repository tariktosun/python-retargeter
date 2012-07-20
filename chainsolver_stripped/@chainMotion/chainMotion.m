%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   chainMotion.m
%   Tarik Tosun, Princeton University
% Description:
%   Constructor for the chainMotion class.  Contains a chain and a joint
%   angle history for the motion.  Can make imitations and animations.
% Usage:
%   myMotion = chainMotion(chain,angleHist);
%   - or -
%   myMotion = chainMotion(chain,epHist);   % for static chains.
%
% Created 3/19/12
% Last edited 4/14/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function obj = chainMotion(chain, angOrEpHist)
    if(strcmp(chain.joints,'static_chain'))
        epHist = angOrEpHist;     % endpoint history for static chains.
        if(iscell(epHist))
            obj.chain = chain;
            obj.angleHist = [];
            obj.epHist = epHist;
            obj.numFrames = size(epHist,2);
            obj = class(obj, 'chainMotion');
        else
            error('epHist must be a cell array of endpoint matrices');
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%       Vanilla Constructor:     %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        angleHist = angOrEpHist;    % angle history for normal chains.
        %%% check args: %%%
        if(size(angleHist,2)~=numDof(chain))
            error('wrong number of angles');
        end
        %%%%%%%%%%%%%%%%%%%%
        obj.chain = chain;
        obj.angleHist = angleHist;
        obj.epHist = [];
        obj.numFrames = size(angleHist,1);

        obj = class(obj, 'chainMotion');
    end
end
