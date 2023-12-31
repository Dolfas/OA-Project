%% Solution for the task 2
clc
x = linspace(-1.5,1.5);
y = linspace(-2.5,2.5);
[X,Y] = meshgrid(x,y);
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = ((sqrt((x(j)+1).^2+y(i).^2)-2).^2+(sqrt((x(j)-3).^2+y(i).^2)-3).^2);
     end
end

contour(X,Y,values, 1, 'LineWidth', 1.1)

%plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Cost Function with two Anchor points}', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{y}', 'Interpreter','latex') ;

%scatter3(0.5,1.5,0,'r') % point where the cost function value is approximately zero

%% Comments 
%In order to get a single global minimizer we must use 3 Anchors. 

x = linspace(-1.5,1.5);
y = linspace(-2.5,2.5);
[X,Y] = meshgrid(x,y);
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = ((sqrt((x(j)+1).^2+y(i).^2)-2).^2+(sqrt((x(j)-3).^2+y(i).^2)-3).^2)+(sqrt((x(j)+2).^2+(y(i)+1).^2)-3).^2;
     end
end

contour(X,Y,values, 35, 'LineWidth', 1.1)

%plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Cost Function with three Anchor points}', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{y}', 'Interpreter','latex') ;

%scatter3(0.5,1.5,0,'r') % point where the cost function value is approximately zero
