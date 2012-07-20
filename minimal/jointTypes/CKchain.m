%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CKchain.m
% Written by Tarik tosun
% Created 4/26/12
% Description:
%   Returns a joints object representing a chain of CKbots.  Calls CKbot.m
%   to get parameters for each individual bot.
% Usage:
%   joints = CKchain({o t o t ... o 'N'})
%       Where o is the orientation of the next link relative the previous
%       link
%       t is the type of link ('UB', 'CR', or 'N').  Must end in 'N'
%       ('none'). 
% Last Edited 4/26/12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chain = CKchain(bots, Ltotal)
    if(mod(size(bots,2),2)~=0)
        error('argument must have even number of elements');
    end
    N = size(bots,2)/2-1;
    Lbot = Ltotal/N;
    l1 = 57.69;
    l2 = 32.75;
    % scale;
    L1 = (l1/(l1+l2))*Lbot;
    L2 = (l2/(l1+l2))*Lbot;
    
    LB = zeros(1,N);
    UB = zeros(1,N);
    names = cell(1,N+1);
    DHfuncs = cell(1,N+1);
    NL = zeros(1,N);
    % set orientation:
    if(strcmp(bots{2},'UB'))
        l = L1;
    else
        l = 0;
    end
    DHfuncs{1} = inline(['[0 180 ' num2str(l) ' ' num2str(bots{1}) ']']);
    names{1} = 'orient';
    
    i = 2;  % input index
    j = 1;  % joint index
    nextType = '';
    while(~strcmp(nextType,'N')) %while links remain
    %for i=1:2:2*N
        type       = bots{i};
        nextOrient = bots{i+1};
        nextType   = bots{i+2};
        [n lb ub dh nl] = CKbot(Lbot,type,nextType,nextOrient); 
        names{j+1} = n;
        LB(j) = lb;
        UB(j) = ub;
        DHfuncs{j+1} = dh;
        NL(j) = nl;
        
        i=i+2;
        j=j+1;
    end
    
    J = joints(names, LB, UB, '3D_DH', DHfuncs, NL);

    orig = [0 0 0];
    lengths = ones(1,N)*Lbot;
    chain = chain3d(orig, lengths, J);
    chain = setJointAngles(chain, zeros(1,N));
    ep = chain.endpoints(2:end,1);
    chain.lengths = abs(ep') - [0, abs(ep(1:end-1)')];
end