%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% objective_globalInt_eef.m
% Written by Tarik tosun
% Created 9/14/11
% Description:
%   simultaneous engine including end effector field in the objective
%   function.
%
% Last Edited: 9/14/11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function objVal = objective_globalInt_eef(angles, chain, spacing, ...
                                        anonField, EEPotential, EEGoal)
% Find EE Contribution
    EEVal = EE_objective(angles, chain, spacing,EEPotential, EEGoal);
% Overall Objective:
    poti = potIntegral_global_anon(angles, chain, spacing, anonField);
    objVal = poti - EEVal;      %potential inverted for fmincon.                            
end