%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 						OCTAVE VERSION
% potIntegral.m
% Written by Tarik Tosun, USC 
% Created 7/20/11
% Meant for use with the seq_fmincon optimizer, which finds minimum values.
%  for this reason, POTENTIAL IS INVERTED in this function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function poti = potIntegral(origin, length, py, spacing, chainField)
    mesh = chainField.mesh;
    potential = -chainField.potential;
    ep = olea2lep3d(origin,length,py);
    
    %mesh the limb:
    if(spacing == 0)
        meshpoints = ep(2,:)';
    else
        lpoints = spacing:spacing:length;  %mesh distances along limb length.
        limbVect = ((ep(2,:)-ep(1,:))/length)'; %limb unit vector
        meshpoints = repmat(ep(1,:)',size(lpoints)) + kron(lpoints,limbVect);
    end

    %compute and sum potential:
    poti = sum(interp3(mesh{1},mesh{2},mesh{3},potential,...
               meshpoints(1,:),meshpoints(2,:),meshpoints(3,:)));
end