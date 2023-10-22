%% Solution for task 7
clc
x = linspace(-12,12);
y = linspace(-12,14);
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
        values(i,j) =((-b.^2+1)*(x(j)+1)-a*b*y(i)).^2+(-a*b*(x(j)+1)+y(i)*(-a.^2+1)).^2;
     end
end
contour(x,y, values,40, 'ShowText','off')
hold on 

% plot design
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Angle Measurement Cost Function} $||(I-u_1u_1^T)(x-a_1)||^2$', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{y}', 'Interpreter','latex') ;
scatter3(-1,0,0,'r','filled')
text(-1,3,'\textbf{Anchor 1}','Interpreter','latex')

% 2 Anchor Points
subplot(2,1,2); 
values=[0];
for i=1:length(y)
    for j=1:length(x)
        values(i,j) =((-d.^2+1)*(x(j)-3)-c*d*y(i)).^2+(-c*d*(x(j)-3)+y(i)*(-c.^2+1)).^2 +((-b.^2+1)*(x(j)+1)-a*b*y(i)).^2+(-a*b*(x(j)+1)+y(i)*(-a.^2+1)).^2;  
    end
end
contour(x,y, values, 25, 'Showtext', 'off')
hold on 

% plot design 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Angle Measurement Cost Function} $\sum_{k=1}^{2} ||(I-u_ku_k^T)(x-a_k)||^2$', 'Interpreter','latex')
xlabel('\textbf{x}','Interpreter','latex');
ylabel('\textbf{y}', 'Interpreter','latex') ; 
scatter3(-1,0,0,'r','filled')
scatter3(3,0,0,'r','filled')
text(-2.3,3,'Anchor 1','Interpreter','latex')
text(1.2,3,'Anchor 2','Interpreter','latex')
