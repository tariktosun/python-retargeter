%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% easy_chain_builder.m
% Tarik Tosun, 2012-07-18
% Description:
%     Makes building a chain3d object minimally difficult.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [chainout] = easy_chain_builder(lengths)
   names = cell(size(lengths))
   lbounds = -120 * ones(size(lengths))
   ubounds = 120 * ones(size(lengths))
   chainout = chain3d([0 0 0],lengths, names, lbounds, ubounds, '2D_simple')
end
