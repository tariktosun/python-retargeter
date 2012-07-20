% lep2olea3d.m, Tarik Tosun
% static method for chain3d class
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % lep2olea3d converts a chain description in lep format to olea
   % format.
   function [origin, lengths, pyAngles] = lep2olea3d(endpoints)
      % Allocate space:
      N = size(endpoints,1)-1;
      lengths = zeros(N,1);
      pyAngles = zeros(N,2);

      origin = endpoints(1,:);
      prev = origin;
      for i=1:(N)
          delta = endpoints(i+1,:) - prev;  
          [yaw,pitch,R] = cart2sph(delta(1),delta(2), delta(3));
          pyAngles(i,1) = toDegrees(pitch);  
          pyAngles(i,2) = toDegrees(yaw);
          lengths(i) = R;
          prev = endpoints(i+1,:);
      end
   end       