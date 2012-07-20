% display.m, Tarik Tosun
% for chain3d class
% created 7/18/11

function display(obj)
    fprintf('class: %s\n',class(obj));
    disp('properties:')
    disp('  numlinks:');
    disp(obj.numlinks);
    disp('   lengths:');
    disp(obj.lengths);
    disp('  endpoints: ');
    disp(obj.endpoints);
    disp('   joints:');
    obj.joints
    fprintf('  chainfield: %ix%i %s\n', size(obj.chainfield,1),size(obj.chainfield,2),class(obj.chainfield));
    disp('  anonfield:');
    disp(obj.anonfield);
end