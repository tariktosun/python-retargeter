% setup.m
% Tarik Tosun
% creates a dummy chain and chainMotion so Matlab knows they are classes.
% Based heavily on cloudsetup.m

c2 = chain3d([0 0 0],[2 2], {'foo','bar'}, [-120 -120], [120 120], '2D_simple');
kMotion = chainMotion(c2, [1 2]);

