%% Solution for task 7
x = linspace(-20,20);
y = linspace(-20,20);
[X,Y] = meshgrid(x,y);
a = cos(2*pi/9);
b = sin(2*pi/9);
c = cos(7*pi/9);
d = sin(7*pi/9);

% 1 Anchor Point
subplot(2,1,1); 
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = ((-(a.^2)+1)*(x(j)+1)-a*b*y(i)).^2+(-a*b*(x(j)+1)+y(i)*(-(b.^2)+1));
     end
end
contour(x,y, values, 'ShowText','on')
hold on 

% plot design
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('Angle Measurement Cost Function for 1 Anchor Point', 'Interpreter','latex')
xlabel('x','Interpreter','latex');
ylabel('y', 'Interpreter','latex') ;
scatter3(-1,0,0,'r','filled')
text(-2,3,'Anchor 1','Interpreter','latex')

% 2 Anchor Points
subplot(2,1,2); 
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) = ((-c.^2+1)*(x(j)-3)-c*d*y(i)).^2+(-c*d*(x(j)-3)+y(i)*(-d.^2+1)) +((-a.^2+1)*(x(j)+1)-a*b*y(i)).^2+(-a*b*(x(j)+1)+y(i)*(-b.^2+1));
     end
end
contour(x,y, values, 'ShowText','on')
hold on 

% plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('Angle Measurement Cost Function for 2 Anchor Points', 'Interpreter','latex')
xlabel('x','Interpreter','latex');
ylabel('y', 'Interpreter','latex') ; 
scatter3(-1,0,0,'r','filled')
scatter3(3,0,0,'r','filled')
text(-2,3,'Anchor 1','Interpreter','latex')
text(2.2,3,'Anchor 2','Interpreter','latex')

%%
clc