%% Main for task 12
clear;
clc;

traj = input("Press 1 for 'pear' shaped trajectory or 2 for spiral trajectory.\n");
if traj == 1
    load('Task9/pear_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
elseif traj == 2
    load('Task9/spiral_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
else
    fprintf('Invalid input.')
end

T = length(v);
n_anchors = length(a);
delta = tref(2)-tref(1); %time between points is always the same
rng(0); %set seed to be the same whenever we run the script for consistency
  
scalar = 1; %To add more or less noise
r_dev = scalar*0.1*10; %standard deviation for ranges
v_dev = (scalar*0.1)/sqrt(2); %standard deviation for velocity

r_noise = r_dev * randn(size(r)); %create gaussian white noise
v_noise = v_dev *randn(size(v));

r_noisy = r + r_noise; %add noise
v_noisy = v + v_noise;

mius = [0, 1]';
x = zeros(T,length(mius)*2);
MNE = zeros(length(mius),1); %Create matrix for error in each miu
cont = 1;
for i= 1:length(mius)
    miu = mius(i);
    [x(:,cont:cont+1)] = cvx_motion_trajectory(T, n_anchors, a, r_noisy, delta, miu, v_noisy); %Solve noisy CVX problem
    MNE(i) = (norm(x(:,cont:cont+1)-xgt))/T; %
    cont = cont + 2;
end
plot_trajectory(x,xgt, mius);
%% Solve CVX problem
function [x] = cvx_motion_trajectory(T, n_anchors, anchors, range, delta, miu, v)
    cvx_begin quiet
        variable x(T, 2);
        expression v_hat(T,2);
        %Build cost function
        static_cost = 0;
        for i = 1:T 
            for j = 1:n_anchors 
                static_cost = static_cost + square_pos(norm(x(i, :) - anchors(j, :)) - range(i, j));
            end
            if i == 1
                v_hat(i,:) = (x(i + 1, :) - x(i, :))/(delta);
            elseif i == T
                v_hat(i,:)= (x(i, :) - x(i-1, :))/(delta);
            else
                v_hat(i,:) = (x(i + 1, :) - x(i - 1, :))/(2*delta);
            end
        end
        dynamic_cost = power(2,norm(v_hat - v));
        % Define the objective function as the sum of static and dynamic costs
        minimize(static_cost+miu*dynamic_cost)
    cvx_end
end
%% Plot trajectory
function plot_trajectory(x_values, xgt,mius)
    fig = figure;
    set(fig, 'Position', [100,100,900,350]');
    cont_g = 1;
    for i = 1:length(mius)
        subplot(1, 2, i);
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