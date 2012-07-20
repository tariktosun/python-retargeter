%% create the right angle from demo:
figure; hold on;
grid on;
line([1 0 -1],[1 0, 1],'LineWidth',2,'Color',[0 0 0]); 
p1 = @(x,y) (sqrt(x.^2+y.^2));
p2 = @(x,y) (sqrt((x+1).^2+(y-1).^2));
p3 = @(x,y) (sqrt((x-1).^2+(y-1).^2));

[x,y] = meshgrid(-2:0.1:2);
field = p1(x,y)+p2(x,y)+p3(x,y);
contour(x,y,field,50);
xlabel('x'); ylabel('y');
axis equal;
axis([-1.5 1.5 -1.5 1.5]);