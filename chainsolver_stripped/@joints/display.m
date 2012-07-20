% display.m, Tarik Tosun
% for joints class
% created 9/8/11

function display(obj)
    fprintf('class: %s\n',class(obj));
    disp('properties:')
    disp('   names: ');
    disp(obj.names);
    disp('   Ubounds: ');
    disp(obj.Ubounds);
    disp('   Lbounds: ');
    disp(obj.Lbounds);
    disp('   ForwardKinematics:');
    disp(obj.ForwardKinematics);
    disp('   angles: ');
    disp(obj.angles);
    disp('   FKparams:');
    disp(obj.FKparams);
    disp('   newLimb:');
    disp(obj.newLimb);
end