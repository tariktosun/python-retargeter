% headSphere.m
% draws a head sphere.
% Tarik Tosun

function headSphere()
    [x,y,z] = sphere();
    x = 100*x; y = 100*y; z = 100*z;
    y = y + 250;
    hold on; surf(x,y,z);
    
    [x,z,y] = cylinder();
    x = x*40; z = z*40; y = y*200;
    hold on; surf(x,y,z);
end