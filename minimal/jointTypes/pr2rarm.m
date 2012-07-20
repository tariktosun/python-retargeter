% Tarik Tosun, Princeton University
% pr2 right arm simulation
%
% 3-link, 4 dof arm representing the PR2's shoulder, upper arm, and
% forearm.
%
% Follows the conventions for the actual PR2 layed out in the PR2_boxer
% package.  All joints are neutral at zero.  Shoulder yaw (pan) is to the
% front of the body at 0.  Upward tilt of the shoulder and flew of the
% elbow are both negative.
%
% Created 4/21/12

function arm = pr2rarm(LT)
    % link lengths
    
    Ls = LT*300/1021;   %mm
    Lua = LT*400/1021;
    Lfa = LT*321/1021;

    orient = inline('[0, 0, 0, 90]','x');  %initial orientation.
    s_yaw = inline(['[0, y-90, ' num2str(Ls) ', 90]'],'y');     nl(1) = 1;
    s_tilt = inline('[0, t, 0, 90]','t');                       nl(2)=0;
    s_roll = inline(['[0, 0, ' num2str(Lua) ', -r+90]'],'r');  nl(3)=1;
    e_flex = inline(['[0, -f, ' num2str(Lfa) ', 0]'],'f');      nl(4)=1;
    
    % final roll not implemented because there's nothing to roll withour
    % wrist!

    LB = [-130.94 -30 -45 -131.78];
    UB = [40.94 80  223 5.73];
    
    names = {'orient','s_yaw', 's_tilt', 's_roll', 'e_flex'};
    DHfuncs = {orient, s_yaw, s_tilt, s_roll, e_flex};
    armJoints = joints(names, LB, UB, '3D_DH', DHfuncs, nl);

    % make chain:
    orig = [0 0 0];
    lengths = [Ls Lua Lfa];
    arm = chain3d(orig, lengths, armJoints);
end
