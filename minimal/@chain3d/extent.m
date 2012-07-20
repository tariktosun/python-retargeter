% extent.m, Tarik Tosun
% for chain3d class

%extent function returns the [xmin xmax;ymin ymax;zmin zmax] for
%the endpoints matrix.
function extents = extent(obj)
    extents(1,1) = min(obj.endpoints(:,1)); %xmin
    extents(1,2) = max(obj.endpoints(:,1)); %xmax
    extents(2,1) = min(obj.endpoints(:,2));
    extents(2,2) = max(obj.endpoints(:,2));
    extents(3,1) = min(obj.endpoints(:,3));
    extents(3,2) = max(obj.endpoints(:,3));
end