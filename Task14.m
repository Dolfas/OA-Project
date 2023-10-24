%% Task 14 script
clc
load('mh370.mat', 'xgt', 'vgt', 'tref', 'a', 'r', 'u', 'v', 'rr');

%% Problem formulation
figure
%still in progress - a ser feito por Alex
subplot(2,1,1); 
x0=(xgt(1,:))';
v_x = linspace(-5,5);
v_y = linspace(-5,5);
[X,Y] = meshgrid(v_x,v_y);

for i=1:length(v_y)
    for j=1:length(v_x)
        values(i,j) = cost_function([v_x(j);v_y(i)], a, x0,tref, r, rr);
     end
end
contour(v_x,v_y, values,50, 'ShowText','off');
hold on 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Cost Function contour lines, as a function of the velocity vector ($x_0$ fixed to true value)}', 'Interpreter','latex')
xlabel('\textbf{Velocity x}','Interpreter','latex');
ylabel('\textbf{Velocity y}', 'Interpreter','latex') ;
scatter3(v(1,1),v(1,2),0,'r','filled')
text(1.5,-1,'\textbf{True $v$}','Interpreter','latex')

subplot(2,1,2); 
x0_x = linspace(-25,25);
x0_y = linspace(-25,25);
[X,Y] = meshgrid(x0_x,x0_y);

for i=1:length(x0_y)
    for j=1:length(x0_x)
        values(i,j) = cost_function(v(1,:), a, [x0_x(j);x0_y(i)],tref, r, rr);
     end
end
contour(x0_x,x0_y, values,40, 'ShowText','off');
hold on 
xline(0, 'Color', 'k', 'LineWidth', 0.5);
yline(0, 'Color', 'k', 'LineWidth', 0.5);
title('\textbf{Cost Function contour lines, as a function of the inicial position $x_0$ (fixed to true value of the velocity)}', 'Interpreter','latex')
xlabel('\textbf{Inicial position x-axis}','Interpreter','latex');
ylabel('\textbf{Inicial position y-axis}', 'Interpreter','latex') ;
ylim([-25 25])
xlim([-25 25])

scatter3(x0(1),x0(2),0,'r','filled')
text(-19,15,'\textbf{True $x_0$}','Interpreter','latex')


function F = cost_function(v, a, x0 ,tref, r, rr)
    delta=tref(2) - tref(1);
    F=0;
    derivative_term=0;
    for i = 1:length(tref) 
        if i == 1
            derivative_term = ( norm(x0+v*tref(i+1)-a') - norm(x0+v*tref(i)-a') )/(delta);
        elseif i == length(tref) 
            derivative_term = ( norm(x0+v*tref(i)-a') - norm(x0+v*tref(i-1)-a') )/(delta);
        else
            derivative_term = ( norm(x0+v*tref(i+1)-a') - norm(x0+v*tref(i-1)-a') )/(2*delta);
        end
    F = F + (norm(x0+v*tref(i)-a') - r(i)).^2 + norm(v)*((derivative_term - rr(i)).^2);
    end
end