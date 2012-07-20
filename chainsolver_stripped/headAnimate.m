function headAnimate(varargin)
    figure; view([0 90]); grid on; headSphere;
    animate(varargin{:});
end