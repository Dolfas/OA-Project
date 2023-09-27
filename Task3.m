%% Solution of section 3
%% Task 1 repeated 
x = linspace(-5,5);
valores = [0];
for i=1:length(x)
   valores(i) = max(abs(x(i)-2)-1,0).^2;
end
plot(x,valores)
title('Relaxed Cost Function: $(|x-2|-1)^2_+$', 'Interpreter','latex')
xlabel('x','Interpreter','latex');
ylabel('Relaxed Cost Function value', 'Interpreter','latex') ;
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
%% Task 2 repeated 
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

%% Comments

% The solutions are more ambiguous than previously, since the solution
% space is bigger than before (we have more solution options). 
