%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simultaneous.m
% Written by Tarik Tosun
% Created 9/4/11
% Description:
%   simultaneous optimizer engine.  Computes a global potential integral
%   (by calling an integrator function), and attempts to minimize this
%   global integral by manipulating the chain's joint angles.
% Last Edited: 4/8/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [newChain, fitParams] = simultaneous(chainField, source, chain, spacing, varargin)
    %%% Constants %%%
    MAXITER = 200;
    TOLERANCE = 0.00001;
    %%%%%%%%%%%%%%%%%
    
    if(nargin==6)
        if(strcmp(varargin{1},'cost_joints_ee'))
            EEratio = varargin{2};
            objType = 'cost_joints_ee';
        elseif(strcmp(varargin{1},'cost2_joints_ee'))
            EEratio = varargin{2};
            objType = 'cost2_joints_ee';
        else
            objType = 'potIntegral_eef';
            EEPotential = varargin{1};
            EELocation = varargin{2};
        end
    elseif(nargin==4)
        objType = 'potIntegral';
    else
        error('Wrong number of arguments');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%     Integrator Selection:      %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(strcmp(class(chainField), 'chainField3d'))
        error('No global integrator for chainField3ds!')
    elseif(strcmp(class(chainField),'function_handle'))
        if(strcmp(objType,'potIntegral'))
            f = @(angles)potIntegral_global_anon(angles,chain,spacing,chainField);
            % find best possible objective. must invert angles b/c function
            % intend for use with optimizer format
            perfect_fit = -potIntegral_global_anon(source.joints.angles',source,spacing,chainField);
        elseif(strcmp(objType,'potIntegral_eef'))
            f = @(angles)objective_globalInt_eef(angles,chain,spacing, ...
                                        chainField,EEPotential,EELocation);
            perfect_fit = -objective_globalInt_eef(source.joints.angles',source,spacing,...
                                        chainField,EEPotential,source.endpoints(end,:));
            % source.endpoints(end,:) is source end effector.
        end
    else
        %%%     JOINTS_EE HERE!!!   %%%
        if(strcmp(objType,'cost_joints_ee'))
            f = @(angles)cost_joints_ee(angles,chain,source,EEratio);
            perfect_fit = 1;    % meaningless
        elseif(strcmp(objType,'cost2_joints_ee'))
            f = @(angles)cost2_joints_ee(angles,chain,source,EEratio);
            perfect_fit = 1;    % meaningless
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            error('chainField must be either chainField3d or AFF');
        end
    end    
    
    lowBounds = chain.joints.Lbounds;
    highBounds = chain.joints.Ubounds;
    angles = chain.joints.angles;
    
    %Perform optimization:
    %%% FOR MATLAB: %%%
    
    % debug:
    %options = optimset('Algorithm','sqp','display','iter');%,'MaxIter',1000,'MaxFunEvals',1000,'TolFun',1e-20,'TolCon',1e-20,'TolX',1e-20);
    options=optimset('fmincon');
    options.Algorithm='active-set';
  
    [optAngles, minInt] = fmincon(f,angles',[],[],[],[],lowBounds',highBounds',[],options);
    %%%%%%%%%%%%%%%%%%%
    %%% FOR OCTAVE: %%%
    %[pyOpt, minInt, info, iter, nf, lambda] = sqp(py',f,[],[],lowBound',highBound',MAXITER,TOLERANCE);
    %%%%%%%%%%%%%%%%%%%
    
    optAngles = optAngles';
    
    newChain = setJointAngles(chain, optAngles);    %return this.
    numLinks = chain.numlinks;
    lengths = chain.lengths;
    if(spacing == 0)
        fitParams.num_int_points = numLinks;
    else
        n = 0;
        for i=1:numLinks
            n = n + size((spacing:spacing:lengths(i)),2);
        end
        fitParams.num_int_points = n;
    end
    fitParams.actual_fit = -minInt;            %return this.
    fitParams.perfect_fit = perfect_fit;
end