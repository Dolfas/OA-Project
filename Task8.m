%% Solution for task 8
%% Problem formulation
clc
a1 = ([-1,0]).';
a2 = ([3,0]).';
r1 = 2;
r2 = 3;
a = cos(2*pi/9); %40º
b = sin(2*pi/9);
c = cos(7*pi/9); %140º
d = sin(7*pi/9);

u1 = [1-a^2,-a*b;-a*b,1-b^2]; % I-u_k*(u_k)^T
u2 = [1-c^2,-c*d;-c*d,1-d^2];

cvx_begin quiet
    variable point(2,1);
    minimize(square_pos(norm(point-a1)-r1)+square_pos(norm(point-a2)-r2)+sum_square(u1*(point-a1))+sum_square(u2*(point-a2)));
cvx_end;

fprintf('The point that minimizes the previous function is: (%f , %f) \n', point(1), point(2))

%% Plotting the Optimization solution on the task3.2 contour plot
x = linspace(-1,2);
y = linspace(-2.5,2.5);
[X,Y] = meshgrid(x,y);
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = ((-c.^2+1)*(x(j)-3)-c*d*y(i)).^2+(-c*d*(x(j)-3)+y(i)*(-d.^2+1)) +((-a.^2+1)*(x(j)+1)-a*b*y(i)).^2+(-a*b*(x(j)+1)+y(i)*(-b.^2+1))+(max(sqrt((x(j)+1).^2+y(i).^2)-2,0).^2+max(sqrt((x(j)-3).^2+y(i).^2)-3,0).^2);
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
