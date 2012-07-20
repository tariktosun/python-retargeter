%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% potIntegral_global_anon.m
% Written by Tarik Tosun
% Created 9/4/11
% Meant for use with the simul_sqp_anon optimizer.
% POTENTIAL IS INVERTED in this function.
% This function uses AFF's.
% This function essentially iterates the procedure used in
% potIntegral_anon.m
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function poti = potIntegral_global_anon(angles, chain, spacing, anonField)
    %%% Argument Checking %%%
    if(~strcmp(class(anonField),'function_handle'))
        error('This function requires an AFF (Anonymous Field Function).');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    numLinks = chain.numlinks;
    lengths = chain.lengths;
    ep = forwardKinematics(chain,angles'); %flipped for fmincon, flip back.
    poti = 0;
    for i = 1:numLinks
        %mesh the limb:
        if(spacing == 0) %indicates endpoint-only meshing.
            meshpoints = ep(i+1,:)';
        else
            lpoints = spacing:spacing:lengths(i); %mesh distance along limb length.
            limbVect = ((ep(i+1,:)-ep(i,:))/length(i))'; %limb unit vector
            meshpoints = repmat(ep(i,:)',size(lpoints))+kron(lpoints,limbVect);
        end
        
        %Debug:
        %poti(i,1) = -sum(anonField(meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
        
        %compute and sum potential from this limb:
        poti = poti - sum(anonField(meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
    end
end