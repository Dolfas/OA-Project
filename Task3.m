%% Solution of section 3
%% Task 1 repeated 
clc
x = linspace(-6,10);
valores = [0];
for i=1:length(x)
   valores(i) = max(abs(x(i)-2)-1,0).^2;
end
plot(x,valores)
title('\textbf{Relaxed Cost Function:} $(|x-2|-1)^2_+$', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{Relaxed Cost Function value}', 'Interpreter','latex') ;
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);

%% Task 2 repeated 
clc
x = linspace(-1.5,1.5);
y = linspace(-2.5,2.5);
[X,Y] = meshgrid(x,y);
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = (max(sqrt((x(j)+1).^2+y(i).^2)-2,0).^2+max(sqrt((x(j)-3).^2+y(i).^2)-3,0).^2);
     end
end
contour(x,y, values, 30, 'LineWidth', 1.1)
hold on 
%plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Relaxed Cost Function with two Anchor points}', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{y}', 'Interpreter','latex') ;

%% Comments

% The solutions are more ambiguous than previously, since the solution
% space is bigger than before (we have more solution options). 
