% Tarik Tosun, Princeton University
% Returns a single CKbot link of length len and type type.  'next'
% speficies the type of the next CKbot in the chain.  This is done for
% length assignment in the DH parameters.  nO specifies the
% orientation of the next link about the link axis.
%
% Valid types:
%   UB - Ubar model, moves in pitch
%   CR - Continuous Rotation, moves in roll
%   N - end of chain.

function [n lb ub dh nl] = CKbot(len, type, next, nO)
    %l1 = 32.75;
    %l2 = 57.69;
    l1 = 57.69;
    l2 = 32.75;
    % scale;
    L1 = (l1/(l1+l2))*len;
    L2 = (l2/(l1+l2))*len;

    if(strcmp(type,'UB'))
        if(strcmp(next,'UB'))       % UB -> UB
            l = L1+L2; 
            n = 'UBUB';
            nl = 1;
        elseif(strcmp(next,'CR'))   % UB -> CR
            l = L2;
            n = 'UBCR';
            nl = 0;
        elseif(strcmp(next,'N'))
            l = L2;
            n = 'UBN';
            nl = 1;
        else
            error('invalid specifier for next');
        end
        lb = -90;   ub = 90;
        dh = inline(['[0 p ' num2str(l) ' ' num2str(nO) ']'],'p');
    elseif(strcmp(type,'CR'))
        if(strcmp(next,'UB'))        %CR -> UB
            l = L1+L2+L1;
            n = 'CRUB';
            nl = 1;
        elseif(strcmp(next,'CR'))    %CR -> CR
            l = L1+L2;
            n = 'CRCR';
            nl = 0;
        elseif(strcmp(next,'N'))
            l = L1+L2;
            n = 'CRN';
            nl = 1;
        else
            error('invalid specifier for next');
        end
        lb = -180;  ub = 180;   %no bounds.
        dh = inline(['[0 0 ' num2str(l) ' r]'],'r');
    else
        error('invalid specifier for type');
    end
    
%{
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
    %}
    
end