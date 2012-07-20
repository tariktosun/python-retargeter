% checkLimits.m, Tarik Tosun
% for chain3d class
% created 8/1/11
		
function checkLimits(obj,py)
    lowLim = [obj.pyLimits(:,1) obj.pyLimits(:,3)];
    highLim = [obj.pyLimits(:,2) obj.pyLimits(:,4)];
    if(~all(all(py>=lowLim)))
        error('angle value outside joint limits.');
    end
    if(~all(all(py<=highLim)))
        error('angle value outside joint limits.');
    end
end