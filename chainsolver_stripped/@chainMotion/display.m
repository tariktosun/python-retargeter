% display.m, Tarik Tosun
% for chainMotion class
% created 3/19/12

function display(obj)
    fprintf('class: %s\n',class(obj));
    disp('properties:')
    disp('    chain:');
    disp(obj.chain);
    disp('    angleHist:');
    disp(size(obj.angleHist))
    disp('    epHist:');
    disp(obj.epHist);
    disp('    numFrames:');
    disp(obj.numFrames);
end

