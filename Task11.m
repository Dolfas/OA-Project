%% Main for task 11
clear;
clc;

traj = input("Press 1 for 'pear' shaped trajectory or 2 for spiral trajectory.\n");
%Load chosen data
if traj == 1
    load('Task10/cost_values_pear.mat'); 
elseif traj == 2
    load('Task10/cost_values_spiral.mat'); 
else
    fprintf('Invalid input.\n')
end

mius = [0.01, 0.1, 1, 10, 100, 1000];

% Creating VE vs RE plot
figure(1);
scatter(dynamic_cost_v, static_cost_v, 'o', 'filled', 'b');
hold on;  
plot(dynamic_cost_v,static_cost_v , 'b-');
title('\textbf{Static Cost vs Dynamic Cost}','Interpreter','latex');
xlabel('\textbf{Dynamic Cost (VE)}','Interpreter','latex');
ylabel('\textbf{Static Cost (RE)}','Interpreter','latex');
xlim([0 max(dynamic_cost_v)]);
ylim([0 max(static_cost_v)]);
grid on;
hold off; 

%Create new figure of evolution of each cost with miu
figure(2);
scatter(mius, dynamic_cost_v, 'o','filled','b');
hold on
scatter(mius, static_cost_v, 'o','filled','r');
plot(mius, dynamic_cost_v, '-b');
plot(mius,static_cost_v,'-r');
title('\textbf{Evolution of cost with $\mu$}','Interpreter','latex');
xlabel('\textbf{$\mu$}','Interpreter','latex');
ylabel('\textbf{Cost value}','Interpreter','latex');
legend('Dynamic Cost (VE)', 'Static Cost (RE)');
grid on
hold off