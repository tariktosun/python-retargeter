%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					OCTAVE VERSION
% sequential.m
% Written by Tarik Tosun, USC Interaction Lab
% Created 7/20/11
% Description:
%   sequential optimizer engine.  linkOptimizer is a function handle
%   pointing to a link optimizer function.  It must take the following
%   form:
%       [ep,py,integral] = linkOptimizer(ep,length,py,pyLimits,spacing,chainField);
%   It is up to the user to pass the appropriate type of field to
%   sequential() in order to make the passed optimizer work.

function [newChain, fitParams] = sequential(chainField, source, chain, spacing,linkOptimizer)
    %%% Argument Checking %%%
    if(~strcmp(class(linkOptimizer),'function_handle'))
        error('linkOptimizer must be a function handle.');
    elseif(~((nargin(func2str(linkOptimizer))==4)))
        error('given linkOptimizer has the wrong number of arguments');
    elseif(~((nargout(func2str(linkOptimizer))==2)))
        error('given linkOptimizer has the wrong number of outputs.');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%

    numlinks = chain.numlinks;
    lengths = chain.lengths;
    fitParams.num_int_points = 0;
    fitParams.actual_fit = 0;
    
    newChain = chain;
    for n=1:numlinks
        [newChain,integral] = linkOptimizer(newChain,spacing,chainField,n);
        
        %update fitParams:
        if(spacing == 0)
            inc = 1;
        else
            inc = size((spacing:spacing:lengths(n)),2);
        end
        fitParams.num_int_points = fitParams.num_int_points + inc;
        fitParams.actual_fit = fitParams.actual_fit + integral;
    end
    fitParams.perfect_fit = -potIntegral_global_anon(source.joints.angles',source,spacing,chainField);
end