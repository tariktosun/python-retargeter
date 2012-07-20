% Tarik Tosun, Princeton University
% Emulates a human arm, 2 links, lengths specified.
% Last Edited 4/13/12

function arm = veryLow22(len)
    orient = inline('[0, 0, 0, -90]','x');  %initial orientation.
    spitch = inline(['[0, 180+p, ' num2str(len(1)) ', 90]'],'p');     nl(1) = 1;
    eyaw = inline(['[0, -y, ' num2str(len(2)) ', 0]'],'y');          nl(2) = 1;

    LB = [-90 -90];
    UB = [90 90];
    
    names = {'orient','spitch','eyaw'};
    DHfuncs = {orient, spitch, eyaw};
    armJoints = joints(names, LB, UB, '3D_DH', DHfuncs, nl);

    % make chain:
    orig = [0 0 0];
    lengths = len;
    arm = chain3d(orig, lengths, armJoints);
end