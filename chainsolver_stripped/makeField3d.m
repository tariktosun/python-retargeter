%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					OCTAVE VERSION
% makeField3d.m
% Tarik Tosun
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Description:
%   Creates a three dimensional field for the chain passed in as argument.
%   res is [xres yres zres] specifying desired field resolution.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chainFieldOut = makeField3d(chain, res)
    %%% Constants %%%
    POTENTIAL = 100;    % potential level on each new limb's surface
    %%%%%%%%%%%%%%%%%
    
    %%% Argument Checking %%%
    if(~strcmp(class(chain),'chain3d'))
        error('Unexpected Inputs');
    elseif(~all(size(res)==[1 3]))
        error('Incorrect res dimensions');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [ranges, steps] = setRanges(chain, res); %[xm xM;ym yM;zm zM],[xs;ys;zs]
    
    mesh = mesh3d(ranges, steps);   % {xmesh ymesh zmesh}
    
    chainFieldOut = makeChainField(mesh, chain, POTENTIAL);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Private Functions:    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    % setRanges method sets range and step values for the mesh.  range
    % format: [xm xM;ym yM;zm zM], step format [xs;ys;zs];
    function [ranges, steps] = setRanges(chain, res)
        %%% Constants %%%
        EDGEBUFFER = 0.05;  %edge buffer, in percent.
        %%%%%%%%%%%%%%%%%
        
        origin = chain.endpoints(1,:);
        length = chain.length;
        max = origin + length*(1+EDGEBUFFER);
        min = origin - length*(1+EDGEBUFFER);
        ranges = [min' max'];
        steps = ((max-min)./res)';
    end

    % mesh3d method creates three dimensional mesh {xmesh ymesh zmesh}
    % given range and step values.  Uses meshgrid.
    function mesh = mesh3d(ranges, steps)
        xdom = ranges(1,1):steps(1):ranges(1,2);
        ydom = ranges(2,1):steps(2):ranges(2,2);
        zdom = ranges(3,1):steps(3):ranges(3,2);
        [x y z] = meshgrid(xdom,ydom,zdom);
        mesh = {x y z};
    end
    
    % makeField method creates a chainField from the given mesh, chain, and
    % potential
    function chainField = makeChainField(mesh, chain, P)
        N = chain.numlinks;
        field = zeros(size(mesh{1}));
        [origin, lengths, pyAngles] = olea(chain);
        endpoints = chain.endpoints;
        for i=1:N
            field = addbar3d(endpoints(i,:),lengths(i),pyAngles(i,:),P,field,mesh);
        end
        chainField = chainField3d(mesh,field);
    end

    % addbar3d method superimposes the potential of a new bar of potential
    % P and spefied start and end points onto the existing field curField
    % with specified mesh.
    function field = addbar3d(origin,length,pyAngle,P,curField,mesh)
        % translation:
        xt = mesh{1} - origin(1);
        yt = mesh{2} - origin(2);
        zt = mesh{3} - origin(3);
        
        % rotation:
        p = toRadians(pyAngle(1))-pi/2;
        y = toRadians(pyAngle(2));       
        X = cos(p)*cos(y) *xt + cos(p)*sin(y) *yt + sin(p)*zt;
        Y = -sin(y)       *xt + cos(y)        *yt + 0     *zt;
        Z = -sin(p)*cos(y)*xt + -sin(p)*sin(y)*yt + cos(p)*zt;
        
        % create and add field:
        R = sqrt(X.^2 + Y.^2);
        fieldToAdd = (-P/pi)*(abs(atan2(R,Z)) - abs(atan2(R,Z-length)));
        field = curField +fieldToAdd;
    end
end