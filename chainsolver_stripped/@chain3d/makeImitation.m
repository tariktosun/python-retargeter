% makeImitation.m, Tarik Tosun
% for use with chain3d.m
% created 7/18/11
% Last Edited 9/4/11
% Description:
%   The makeImitation function makes an imitation of this chain with the
%   passed chain.  fitParams contains information about goodness-of-fit if
%   an engine which returns these parameters is selected.  Otherwise, it is
%   empty.
% Usage:
%   [im,fp] = makeImitation(source, destination, 'seq_sqp_anon', 'AFF',
%                           0.1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newChain, fitParams] = makeImitation(obj,chain,engine,scaleOpt,varargin)
    %%% Constants: %%%
    POTENTIAL = 100;    %potential level on the source chain's surface.
    %%%%%%%%%%%%%%%%%%

    fieldType = 'AFF';  %hard coding this now.  chainField3d's are deprecated.

    % Limb lengths scaling:
    oldLengths = [];
    if(strcmp(scaleOpt,'scale'))
        L1 = sum(obj.lengths);
        L2 = sum(chain.lengths);
        oldLengths = chain.lengths;
        newLengths = (L1/L2)*oldLengths;
        scaled = chain3d(chain.origin, newLengths, chain.joints.names, ...
            chain.joints.Lbounds, chain.joints.Ubounds, ...
            chain.joints.ForwardKinematics);
        chain = setJointAngles(scaled,chain.joints.angles);
    end

    %{
        if(strcmp(fieldType,'chainField3d'))
            if(nargin>4)    %engine parameters or res given
                if(isempty(obj.chainfield)) %both or only res
                    res = varargin{end};
                    [obj, chainfield] = field(obj, res);		%OCTAVE EDIT
                    if(nargin>5)
                        engineParam = varargin{1:end-1};
                        [optChain, fitParams] = chainOpt3d(field,chain,engine,engineParam);
                    else %nargin==4, no engineParam
                        [optChain, fitParams] = chainOpt3d(field,chain,engine);
                    end
                else    %only engine parameters
                    engineParam = varargin{1:end};
                    [obj, chainfield] = field(obj);		%OCTAVE EDIT
                    [optChain, fitParams] = chainOpt3d(field,chain,engine,engineParam);
                end
            else    %no engine parameters or field.
            [obj, chainfield] = field(obj); %field will throw error if not initialized.	%OCTAVE EDIT
                [optChain, fitParams] = chainOpt3d(field,chain,engine);
            end
        elseif(strcmp(fieldType,'AFF'))
    %}
    
    if(strcmp(engine,'cost_joints_ee'))
        aff = [];
    else
        % AFF Case:
        aff = anonfield(obj, POTENTIAL);		%OCTAVE EDIT
    end
    if(nargin>4)
        engineParam = {varargin{1:end}};
        if(strcmp(engine,'objective_global_eef'))
            ep = endpoints(obj);
            EE = ep(end,:);
            engineParam = {engineParam{:}, EE};
        end
        % 11/15/11 - chainOpt3d now takes sources for fit evaluation
        [optChain, fitParams] = chainOpt3d(aff,obj,chain,engine,engineParam{:});
    else
        [optChain, fitParams] = chainOpt3d(aff,obj,chain,engine);
    end

    % end   <-this is for the if commented out above.


    % more limb length scaling:  change lengths back.
    if(strcmp(scaleOpt,'scale'))
        scaled = chain3d(optChain.origin, oldLengths, optChain.joints.names, ...
            optChain.joints.Lbounds, optChain.joints.Ubounds, ...
            optChain.joints.ForwardKinematics);
        newChain = setJointAngles(scaled,optChain.joints.angles);
    else
        newChain = optChain;
    end

    if(~isempty(fitParams))
        fitParams.surface_potential = POTENTIAL;    % initial potential
        fitParams.optimality_ratio = fitParams.actual_fit / fitParams.perfect_fit;
    end
end
