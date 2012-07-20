%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpolateKF.m
% Tarik Tosun, Princeton University
% Description:
%   Interpolates on KF to make a full trajectory.  Used in roptImitation.m
%
% Created 3/20/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function angleHist = interpolateKF(obj, kf, tAngles, N)
    dof = size(tAngles,2);
    angleHist = zeros(N,dof);
    numKF = size(kf,2);
    for n=1:numKF-1
        cur = kf(n);
        next = kf(n+1);
        for t=cur:next
            % linear interpolate
            angleHist(t,:)=interp1([cur;next],[tAngles(n,:); tAngles(n+1,:)],t);
        end
    end
end