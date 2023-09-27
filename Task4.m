%% Solution for task 4
%% Problem formulation
a1 = [-1,0];
a2 = [3,0];
r1 = 2;
r2 = 3;
cvx_begin quiet
    variable point(1,2);
    minimize(square_pos(norm(point-a1)-r1)+square_pos(norm(point-a2)-r2));
cvx_end;
disp(point)
%% Plotting the Optimization solution on the task3.2 contour plot
x = linspace(-1,2);
y = linspace(-2.5,2.5);
[X,Y] = meshgrid(x,y);
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = (max(sqrt((x(j)+1).^2+y(i).^2)-2,0).^2+max(sqrt((x(j)-3).^2+y(i).^2)-3,0).^2);
     end
end
contour(x,y, values, 'ShowText','on')
hold on 
%plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('Relaxed Cost Function with two Anchor points', 'Interpreter','latex')
xlabel('x','Interpreter','latex');
ylabel('y', 'Interpreter','latex') ;
scatter3(point(1),point(2),0,'r','filled')