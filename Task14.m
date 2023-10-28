%% Task 14 script
clc, clear
load('measurements.mat', 'xgt', 'vgt', 'tref', 'a', 'r', 'u', 'v', 'rr'); % 'mh370.mat' can also be used instead of 'measurements.mat'

%% Problem formulation
x0=(xgt(1,:))';         % fixed value for x_0
v_x = linspace(-5,5);
v_y = linspace(-2.5,7.5);
[X,Y] = meshgrid(v_x,v_y);
niu=1;
for i=1:length(v_y)
    for j=1:length(v_x)
        vvalues(i,j) = cost_function([v_x(j);v_y(i)], a, x0,tref, r, rr, niu); %cost function's value for each possible velocity vector
     end
end

%% Plots
figure
contour(v_x,v_y, vvalues,50, 'ShowText','off');
hold on 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Cost Function contour lines, as a function of the velocity vector ($x_0$ fixed to true value)}', 'Interpreter','latex')
xlabel('\textbf{Velocity x}','Interpreter','latex');
ylabel('\textbf{Velocity y}', 'Interpreter','latex') ;
scatter3(v(1,1),v(1,2),0,'r','filled')
text(v(1,1),v(1,2)+0.5,'\textbf{True $v$}','Interpreter','latex')


figure %3d plot
s=surf(v_x,v_y, vvalues);
s.EdgeColor = 'none';
hold on
scatter3(v(1,1),v(1,2),cost_function([v(1,1);v(1,2)], a, x0,tref, r, rr, niu),'r','filled')
legend('\textbf{Cost Function, as a function of the 2D velocity vector ($x_0$ fixed to true value)}','True $v$', 'Interpreter','latex')
hold off

%% Functions to support problem formulation
function residual = residual_func(v, a, x0, tref, r, rr, niu)
    for i = 1:length(tref)
        aux=x0+v*tref(i)-a';
        rR(i)=norm(aux) - r(i);
        rRR(i)= sqrt(niu)*( (v'*(aux)/(norm(aux))) - rr(i));
    end
    residual=[rR,rRR]';
end
function F = cost_function(v, a, x0 ,tref, r, rr, niu)
  
    residual=residual_func(v, a, x0, tref, r, rr, niu);
    F= 0.5*(norm(residual))^2;    

end