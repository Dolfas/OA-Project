%% Inicializations
%load('Task9/task_data.mat');
load('racetrack.mat', 'a', 'r', 'v', 'tref', 'xgt');
anchors = a;
range = r;
delta = tref(2) - tref(1);
T = length(v(:,1));  
n_anchors = length(anchors(:,1));
%% Miu = 1
miu = 1;
[x_1, ~, ~] = cvx_motion_trajectory(T, n_anchors, anchors, range, delta, miu, v); %Solve optimization problem
plot_trajectory(x_1,xgt, miu); %Verify if is the same trajectory
%% Multiple mius + velocity inconsistency
mius = [0.01, 0.1, 1, 10, 100, 1000]';
v_incon = 0.8*v; %Create inconsistency
x_values = zeros(T, 2*length(mius)); %collumns are x y coordinates in 2-to-2 pairs for each miu
static_cost_v = zeros(length(mius),1);
dynamic_cost_v = zeros(length(mius),1);
cont = 1; %counter to add values to matrix x_values
for i = 1:length(mius)
    miu = mius(i);
    [x_values(:,cont:cont+1), static_cost_v(i), dynamic_cost_v(i)] = cvx_motion_trajectory(T, n_anchors, anchors, range, delta, miu, v_incon);
    cont = cont +2;
end
plot_trajectory(x_values,xgt, mius);
save('cost_values.mat', 'static_cost_v', 'dynamic_cost_v'); %Save values for task 11
%% Solve optimization problem
function [x, static_cost, dynamic_cost] = cvx_motion_trajectory(T, n_anchors, anchors, range, delta, miu, v)
    cvx_begin quiet
        variable x(T, 2);
        expression v_hat(T,2);
        % Build cost function
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
        set(fig, 'Position', [100,100,1400,900]');
        cont_g = 1;
        for i = 1:length(mius)
            
            % Create a subplot with 2 rows and 3 columns
            subplot(2, 3, i);
            
            % Plot the group of points
            p1 = plot(x_values(:,cont_g), x_values(:, cont_g+1), 'bo-',  'LineWidth', 1.5); 
            hold on;
            p2 = scatter(xgt(:,1), xgt(:,2), 50, 'rx');
        
            ylim([-0.5,6]);
            
            % Add labels, title, etc., if needed
            title(['Trajectory for Miu = ' num2str(mius(i))]);
            xlabel('X-axis');
            ylabel('Y-axis');
            legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
            cont_g = cont_g +2;
        end
    end
end
