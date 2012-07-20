function EEval = EE_objective(angles, chain, spacing,EEPotential, EEGoal)
    OFFSET = 1;
    ep = forwardKinematics(chain,angles');
    EE = ep(end,:);
    % find number of integration points, scale potential:
    n = 0;
    if(spacing == 0)
        n = chain.numlinks;
    else
        for i=1:chain.numlinks
            n = n + size((spacing:spacing:chain.lengths(i)),2);
        end
    end
    P = EEPotential * n;
    % calculate:
    r = abs(norm(EEGoal - EE));
    EEval = P*OFFSET/(r + OFFSET);   
end