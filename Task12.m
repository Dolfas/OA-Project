%% Task 12 script
load('racetrack.mat', 'a', 'r', 'v', 'tref', 'xgt');
T = length(v);
n_anchors = length(a);
delta = tref(2)-tref(1);

rng(0); %set seed to be the same whenever we run the script for consistency
  
scalar = 3;
r_dev = scalar*0.1; %standard deviation for ranges
v_dev = (scalar*0.1)/sqrt(2); %standard deviation for velocity

r_noise = r_dev * randn(size(r)); %create gaussian white noise
v_noise = v_dev *randn(size(v));

r_noisy = r + r_noise;
v_noisy = v + v_noise;

mius = [0, 1]';
x = zeros(T,length(mius)*2);
MNE = zeros(length(mius),1); %Create matrix for error in each miu
cont = 1;
for i= 1:length(mius)
    miu = mius(i);
    [x(:,cont:cont+1)] = cvx_motion_trajectory(T, n_anchors, a, r_noisy, delta, miu, v_noisy);
    MNE(i) = (norm(x(:,cont:cont+1)-xgt))/T;
    cont = cont + 2;
end
plot_trajectory(x,xgt, mius);
%%
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
%%
function plot_trajectory(x_values, xgt, mius)
    if length(mius) == 1
        % Create a scatter plot for x with circular markers and connecting lines
        p1 = plot(x_values(:,1), x_values(:,2), 'o-', 'LineWidth', 1, 'DisplayName', 'x');
        hold on;
        
        % Create a scatter plot for xgt with 'x' markers
        p2 = scatter(xgt(:,1), xgt(:,2), 'x', 'DisplayName', 'xgt');
        
        xlabel('x');
        ylabel('y');
        title('Trajectory in xoy plane');
        legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
        
        % Hold off to stop overlaying on the same figure
        hold off;
    else
        fig = figure;
        set(fig, 'Position', [100,100,900,350]');
        cont_g = 1;
        for i = 1:length(mius)
            
            % Create a subplot with 2 rows and 3 columns
            subplot(1, 2, i);
            
            % Plot the group of points
            p1 = plot(x_values(:,cont_g), x_values(:, cont_g+1), 'bo-',  'LineWidth', 1.5); 
            hold on;
            p2 = scatter(xgt(:,1), xgt(:,2), 50, 'rx');
        
            ylim([-0.5,6.5]);
            
            % Add labels, title, etc., if needed
            title(['Trajectory for Miu = ' num2str(mius(i))]);
            xlabel('X-axis');
            ylabel('Y-axis');
            legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
            cont_g = cont_g +2;
        end
    end
end

