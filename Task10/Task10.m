%% Inicializations
traj = input("Press 1 for 'pear' shaped trajectory or 2 for spiral trajectory.\n");
if traj == 1
    load('../Task9/pear_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
elseif traj == 2
    load('../Task9/spiral_t9.mat', 'a', 'r', 'v', 'tref', 'xgt');
else
    fprintf('Invalid input.')
end
delta = tref(2) - tref(1);
T = length(v(:,1));  
n_a = length(a(:,1));
%% Miu = 1
miu = 1;
[x_1, ~, ~] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v); %Solve optimization problem
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
    [x_values(:,cont:cont+1), static_cost_v(i), dynamic_cost_v(i)] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v_incon);
    cont = cont +2;
end
plot_trajectory(x_values,xgt, mius);
save('cost_values.mat', 'static_cost_v', 'dynamic_cost_v'); %Save values for task 11
%% Solve optimization problem
function [x, static_cost, dynamic_cost] = cvx_motion_trajectory(T, n_a, a, r, delta, miu, v)
    cvx_begin quiet
        variable x(T, 2);
        expression v_hat(T,2);
        % Build cost function
        static_cost = 0;
        for i = 1:T 
            for j = 1:n_a 
                static_cost = static_cost + square_pos(norm(x(i, :) - a(j, :)) - r(i, j));
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
        
        xlabel('x axis');
        ylabel('y axis');
        xlim([-20 20]);
        ylim([-20,20]);
        title('Trajectory for miu = 1');
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
            xlim([-20 20]);
            ylim([-20,20]);
            
            % Add labels, title, etc., if needed
            title(['Trajectory for Miu = ' num2str(mius(i))]);
            xlabel('x axis');
            ylabel('y axis');
            legend([p1,p2], 'Simulated Trajectory', 'Real trajectory');
            cont_g = cont_g +2;
        end
    end
end
