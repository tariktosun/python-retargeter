%olea2lep3d.m, Tarik Tosun
% static method for chain3d class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% olea2lep3 converts a chain description in olea format to lep format.
   % Euler angles are roll, pitch, and yaw.  Roll is not important because
   % the links are just lines, so pyAngles(:,1) is pitch, (:,2) is yaw
   function endpoints = olea2lep3d(origin, lengths, pyAngles)
       N = size(lengths,1); %number of links
       endpoints = zeros(N+1,3);    %xyz for each endpoint
       endpoints(1,:) = origin;
       prev = origin;
       for i=1:N
           pitch = toRadians(pyAngles(i,1));
           yaw = toRadians(pyAngles(i,2));
           R = lengths(i);
           [x,y,z] = sph2cart(yaw,pitch,R);
           endpoints(i+1,:) = prev + [x y z];
           prev = endpoints(i+1,:);
       end
   end