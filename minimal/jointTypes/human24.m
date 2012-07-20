% Tarik Tosun, Princeton University
% Emulates a human arm, 2 links, lengths specified.
% Last Edited 4/13/12

function arm = human24(len)
    orient = inline('[0, 0, 0, 0]','x');  %initial orientation.
    sroll = inline('[0, r, 0, 0]','r'); nl(1) = 0;
    syaw = inline('[0, 90+y, 0, 90]','y');        nl(2) = 0;
    spitch = inline(['[0, 180+p, ' num2str(len(1)) ', 0]'],'p');        nl(3) = 1;

    epitch = inline(['[0, -p, ' num2str(len(2)) ', 0]'],'p');        nl(4) = 1;

    LB = -120*ones(size(nl));
    %LB = [-110 -90 -50 -170];
    UB = 120*ones(size(nl));
    %UB = [110 90 150 5];
    
    names = {'orient','sroll','syaw','spitch','epitch'};
    DHfuncs = {orient, sroll, syaw, spitch, epitch};
    armJoints = joints(names, LB, UB, '3D_DH', DHfuncs, nl);

    % make chain:
    orig = [0 0 0];
    lengths = len;
    arm = chain3d(orig, lengths, armJoints);
end