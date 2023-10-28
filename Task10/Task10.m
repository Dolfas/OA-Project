%% Inicializations
% To run this script first run this section and then run either the section
% for miu = 1 or multiple mius. Should be ran in project folder.
clear;
clc;
traj = input("Press 1 for 'pear' shaped trajectory or 2 for spiral trajectory.\n");
%Load data
if traj == 1
    load('../Task9/pear_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
elseif traj == 2
    load('../Task9/spiral_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
else
    fprintf('Invalid input.')
end
delta = tref(2) - tref(1); %time between measurements
T = length(v(:,1)); %number of timestamps  
n_a = length(a(:,1)); %number of anchors
%% Miu = 1
miu = 1;
[x_1, ~, ~] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v); %Solve optimization problem
plot_trajectory(x_1,xgt, miu); %Verify if is the same trajectory
%% Multiple mius + velocity inconsistency
mius = [0.01, 0.1, 1, 10, 100, 1000]';
v_incon = 0.8*v; %Create inconsistency
x_values = zeros(T, 2*length(mius)); %collumns are x y coordinates in 2-to-2 pairs for each miu
static_cost_v = zeros(length(mius),1); %cost values for task 11
dynamic_cost_v = zeros(length(mius),1);
cont = 1; %counter to add values to matrix x_values
for i = 1:length(mius)
    miu = mius(i);
    [x_values(:,cont:cont+1), static_cost_v(i), dynamic_cost_v(i)] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v_incon);
    cont = cont +2;
end
plot_trajectory(x_values,xgt, mius);
if traj == 1
    save('cost_values_pear.mat', 'static_cost_v', 'dynamic_cost_v'); %Save values for task 11
elseif traj == 2
    save('cost_values_spiral.mat', 'static_cost_v', 'dynamic_cost_v'); %Save values for task 11
end
%% Solve optimization problem
function [x, static_cost, dynamic_cost] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v)
    cvx_begin quiet
        variable x(T, 2);
        expression v_hat(T,2);
        % Build cost function
        static_cost = 0; 
        for i = 1:T %time sum
            for j = 1:n_a %anchor sum
                static_cost = static_cost + square_pos(norm(x(i, :) - a(j, :)) - r(i, j)); % equivalent to RE
            end
            if i == 1
                v_hat(i,:) = (x(i + 1, :) - x(i, :))/(delta);
            elseif i == T
                v_hat(i,:)= (x(i, :) - x(i-1, :))/(delta);
            else
                v_hat(i,:) = (x(i + 1, :) - x(i - 1, :))/(2*delta);
            end
        end
        dynamic_cost = power(2,norm(v_hat - v)); % equivalent to VE
 
        % Define the objective function as the sum of static and dynamic costs
        minimize(static_cost+miu*dynamic_cost)
    cvx_end
end
%% Plot trajectory
function plot_trajectory(x_values, xgt, mius)
    if length(mius) == 1
        % Plot points of simulated velocity
        p1 = plot(x_values(:,1), x_values(:,2), 'o-', 'LineWidth', 1.25, 'DisplayName', 'x');
        hold on;
        % Plot points of real velocity
        p2 = scatter(xgt(:,1), xgt(:,2), 'x', 'DisplayName', 'xgt','LineWidth', 1,'SizeData',30,'MarkerEdgeColor', 'r');
        xlabel('\textbf{x Coordinate (m)}','Interpreter','latex');
        ylabel('\textbf{y Coordinate (m)}','Interpreter','latex');
        xlim([-20 20]);
        ylim([-20,20]);
        title('$\textbf{Trajectory for } \mathbf{\mu}= 1$','Interpreter','latex');
        legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
        hold off;
    else
        fig = figure;
        set(fig, 'Position', [100,100,1400,900]');
        cont_g = 1; %inicialize counter to iterate through x_values
        for i = 1:length(mius)
            subplot(2, 3, i); %figure with 2 rows and 3 collumns
            p1 = plot(x_values(:,cont_g), x_values(:,cont_g+1), 'o-', 'LineWidth', 1.25, 'DisplayName', 'x'); 
            hold on;
            p2 = scatter(xgt(:,1), xgt(:,2), 50, 'x', 'DisplayName', 'xgt','LineWidth', 1,'SizeData',30,'MarkerEdgeColor', 'r');
            xlim([-20 20]);
            ylim([-20,20]);
            title_string=['$\mathbf{Trajectory\ for\ }\mathbf{\mu}=', num2str(mius(i)), '$'];
            title(title_string, 'Interpreter','latex');
            xlabel('\textbf{x Coordinate (m)}','Interpreter','latex');
            ylabel('\textbf{y Coordinate (m)}','Interpreter','latex');
            legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
            cont_g = cont_g +2;
        end
    end
end