%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 					OCTAVE VERSION
% potIntegral_anon.m
% Written by Tarik Tosun, USC 
% Created 7/20/11
% Meant for use with the seq_fmincon optimizer, which finds minimum values.
% for this reason, POTENTIAL IS INVERTED in this function.
% This function uses AFF's rather than chainField3d objects.
% Finds the integral of the given field over the n'th link of the given
% chain.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function poti = potIntegral_anon(newAngle,chain, spacing, anonField, n)
    %%% Argument Checking %%%
    if(~strcmp(class(anonField),'function_handle'))
        error('This function requires an AFF (Anonymous Field Function).');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%

    angles = chain.joints.angles;
    angles(n) = newAngle;   %swap the manipulated angle into the vector.
    full_ep = forwardKinematics(chain,angles);
    ep = full_ep(n:n+1,:);
    length = chain.lengths(n);
    
    %mesh the limb:
    if(spacing == 0)
        meshpoints = ep(2,:)';
    else
        lpoints = spacing:spacing:length;  %mesh distances along limb length.
        limbVect = ((ep(2,:)-ep(1,:))/length)'; %limb unit vector
        meshpoints = repmat(ep(1,:)',size(lpoints)) + kron(lpoints,limbVect);
    end

    %compute and sum potential:
    poti = -sum(anonField(meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
end