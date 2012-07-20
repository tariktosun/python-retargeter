%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%				 	OCTAVE VERSION
% optLink_sqp.m
% Written by Tarik Tosun, USC Interaction Lab
% Created 7/20/11
% Description:
%   Places the n'th link of the given chain in the given field using sqp.
%   
%
%   Supports both chainField3d objects and anonymous function fields (AFF's),
%   and will call the appropriate potential integral function based on
%   which type of field is passed in as the chainField argument.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [optChain, integral] = optLink_sqp(chain,spacing,chainField,n)
    %%% Constants %%%
    MAXITER = 200;
    TOLERANCE = 0.00001;
    %%%%%%%%%%%%
    if(strcmp(class(chainField),'chainField3d'))
        f = @(pyAngles)potIntegral(ep(1,:),length,pyAngles',spacing,chainField);	%OCTAVE EDIT: transpose of pyAngles for sqp convention.
    elseif(strcmp(class(chainField),'function_handle'))
        f = @(angle)potIntegral_anon(angle,chain,spacing,chainField,n);	%OCTAVE EDIT: see above
    else
        error('chainField must be either chainField3d or AFF');
    end
    
    allLowBounds = chain.joints.Lbounds;
    allHighBounds = chain.joints.Ubounds;
    allAngles = chain.joints.angles;
    angle = allAngles(n);
    lowBound = allLowBounds(n);
    highBound = allHighBounds(n);
   
    %%% FOR MATLAB: %%%
    options = optimset('display','iter');
    [angleOpt, minInt] = fmincon(f,angle',[],[],[],[],lowBound',highBound',[],options);
    %%%%%%%%%%%%%%
   
    
    %{
    [pyOpt, minInt, info, iter, nf, lambda] = sqp(py',f,[],[],lowBound',highBound',MAXITER,TOLERANCE)%OCTAVE EDIT: see above
    %}
    angleOpt = angleOpt';			%OCTAVE EDIT: see above
    newAngles = allAngles;
    newAngles(n) = angleOpt;
    optChain = setJointAngles(chain,newAngles);
    integral = -minInt;
end
