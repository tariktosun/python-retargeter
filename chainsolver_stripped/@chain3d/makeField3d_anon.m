%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					OCTAVE VERSION
% makeField3d_anon.m
% Written by Tarik Tosun, USC Interaction Lab
% Created 7/22/11
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Description:
%   Creates a three dimensional potential field for the chain passed in as
%   argument.  Field is created by superimposing the analytic solutions to
%   the Laplace equation for a three dimensional cylinder of zero radius (a
%   line segment), and is returned as an anonymous function that may be
%   sampled at any (x,y,z) coordinate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function anonFieldOut = makeField3d_anon(chain, potential)
    %%% Argument Checking %%%
    if(~strcmp(class(chain),'chain3d'))
        error('Unexpected Input');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Make the field by adding each link:
    N = chain.numlinks;
    [origin, lengths, pyAngles] = olea(chain);	%OCTAVE EDIT	
    ep = endpoints(chain);		%OCTAVE EDIT
    field = @(x,y,z)0;  %function is zero to start.
    for i=1:N
        field = addbar3d_anon(ep(i,:),lengths(i),pyAngles(i,:),...
                              potential,field);
    end
    anonFieldOut = field;
end

function field = addbar3d_anon(origin,length,pyAngle,P,curField)
    % translation:
    xt = @(x,y,z)x-origin(1);
    yt = @(x,y,z)y-origin(2);
    zt = @(x,y,z)z-origin(3);
    
    %rotation:
    pitch = toRadians(pyAngle(1))-pi/2;
    yaw = toRadians(pyAngle(2));      
    X= @(x,y,z) cos(pitch)*cos(yaw)   *xt(x,y,z)...
              + cos(pitch)*sin(yaw)                *yt(x,y,z)...
              + sin(pitch)                                      *zt(x,y,z);
    Y= @(x,y,z) -sin(yaw)                           *xt(x,y,z)...
              + cos(yaw)                                       *yt(x,y,z)...
              +0                                                         *zt(x,y,z);
    Z= @(x,y,z) -sin(pitch)*cos(yaw)  *xt(x,y,z)...
              + -sin(pitch)*sin(yaw)               *yt(x,y,z)...
              + cos(pitch)                                    *zt(x,y,z);
          
    % create and add field:
    R= @(x,y,z) sqrt(X(x,y,z).^2 + Y(x,y,z).^2);
    fieldToAdd= @(x,y,z) (-P/pi)*(abs(atan2(R(x,y,z),Z(x,y,z)))...
                                                                   -abs(atan2(R(x,y,z),Z(x,y,z)-length)));
    field= @(x,y,z)curField(x,y,z) + fieldToAdd(x,y,z);
end