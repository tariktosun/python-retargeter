%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cost_joints_ee.m
% Written by Tarik tosun
% Created 4/8/12
% Description:
%   simultaneous engine including end effector term and joint-distance-sum
%   term.
%   EEratio is the ratio of end effector weight to the rest of the joints.
% NOTE:
% This is a positive-definite cost function, and cannot be mixed with the
% other 'objective' functions, which are negative-definite objective
% functions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cost = cost_joints_ee(angles, target, source, EEratio)
    Ns = source.numlinks;
    Nt = target.numlinks;
    eps = endpoints(source);   
    ept = forwardKinematics(target,angles');
% end effector term:
    rEE = abs(norm(eps(end,:)-ept(end,:)));
% joints term: sum all excluding first and ee.
    rJoints = 0;
    for i=2:Nt
        t = ept(i,:);
        for j=2:Ns
            s = eps(j,:);
            rJoints = rJoints + abs(norm(s-t));
        end
    end
%overall:
    % normalize for number of source interior joints, multiply by ratio:
    m = (Ns-1); %if EEratio = 1, EE counts as much as any other target joint.
    cost = rEE *m*EEratio + rJoints;
end