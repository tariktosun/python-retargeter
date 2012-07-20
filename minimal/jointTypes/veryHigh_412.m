% Tarik Tosun, Princeton University
% Emulates a human arm, 2 links, lengths specified.
% Last Edited 4/13/12

function arm = veryHigh_412(len)
    orient = inline('[0, 0, 0, 0]','x');  %initial orientation.
    roll = inline('[0, r, 0, 90]','r');                            nl(1) = 0;
    yaw = inline('[0, 90+y, 0, 90]','y');                          nl(2) = 0;
    pitch1 = inline(['[0, 180+p, ' num2str(len(1)) ', 0]'],'p');    nl(3) = 1;

    nl(4) = 0;
    nl(5) = 0;
    pitch2 = inline(['[0, 180+p, ' num2str(len(2)) ', 0]'],'p');    nl(6) = 1;
    
    nl(7) = 0;
    nl(8) = 0;
    pitch3 = inline(['[0, 180+p, ' num2str(len(3)) ', 0]'],'p');    nl(9) = 1;
    
    nl(10) = 0;
    nl(11) = 0;
    pitch4 = inline(['[0, 180+p, ' num2str(len(4)) ', 0]'],'p');    nl(12) = 1;
    

    LB = -150*ones(size(nl));
    UB = 150*ones(size(nl));
    
    names = {'orient','roll1','yaw1','pitch1','roll2','yaw2','pitch2','roll3','yaw3','pitch3','roll4','yaw4','pitch4'};
    DHfuncs = {orient, roll, yaw, pitch1, roll, yaw, pitch2, roll, yaw, pitch3, roll, yaw, pitch4};
    armJoints = joints(names, LB, UB, '3D_DH', DHfuncs, nl);

    % make chain:
    orig = [0 0 0];
    lengths = len;
    arm = chain3d(orig, lengths, armJoints);
end