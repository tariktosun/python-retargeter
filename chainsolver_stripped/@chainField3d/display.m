% display.m, Tarik Tosun
% for chainField3d class
% created 7/18/11

function display(obj)
    disp(class(obj));
    disp('properties:')
    fprintf('  mesh:  %ix%i %s\n', size(cell2mat(obj.mesh),1),size(cell2mat(obj.mesh),2),class(obj.mesh));
    fprintf('  potential: %ix%i %s\n', size(obj.potential,1),size(obj.potential,2),class(obj.potential));
    fprintf('  grad: %ix%i %s\n', size(cell2mat(obj.grad),1),size(cell2mat(obj.grad),2),class(obj.grad));
end