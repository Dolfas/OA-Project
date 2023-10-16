%% Main Script

% Define the bounding box
x_min = -20; % Minimum x coordinate
x_max = 20;  % Maximum x coordinate
y_min = -20; % Minimum y coordinate
y_max = 20;  % Maximum y coordinate

% Initialization and Parameters
T = 100;  % Number of samples

% Load trajectory and anchors datax
traj = readmatrix('trial_3.txt');
anchors = readmatrix('anchors.txt');

%Spiral
%[traj, anchors] = generateSpiralTrajectory(x_min, x_max, y_min, y_max, T);

[simulated_velocity, range, angle] = simulateData(traj, anchors);

save('task_data.mat', 'simulated_velocity', 'range', 'angle', 'anchors'); %save generated data in file

% Display the trajectory and anchors
plotTrajectoryAndAnchors(traj, anchors);

%% Function to Simulate Velocity, Range, and Angle
function [simulated_velocity, range, angle] = simulateData(traj, anchors)
    % Constants and parameters
    sampling_rate = 2;  % Sampling rate (Hz)DUVIDA SOBRE ISTO
    delta = 1 / sampling_rate; % Time between measurements ANTES TAVA 0.1 (O CAPS LOCK SERVE PA NAO ME ESQUECER DE REVER)
    
    % Calculate simulated velocity
    simulated_velocity = calculateVelocity(traj, delta);
    
    % Calculate range at each point
    range = calculateRange(traj, anchors);
    
    % Calculate angle at each point
    angle = calculateAngle(traj);
end

%% Function to Calculate Simulated Velocity
function simulated_velocity = calculateVelocity(traj, delta)
    simulated_velocity = zeros(length(traj), 2); %DUVIDA SOBRE O FIXED RATE 2HZ
    
    for i = 1:length(traj)
        if i == 1
            simulated_velocity(i,:) = (traj(i+1,:)-traj(i,:))/delta;
        elseif i == length(traj)
            simulated_velocity(i,:) = (traj(i,:)-traj(i-1,:))/delta;
        else
            simulated_velocity(i,:) = (traj(i+1,:)-traj(i-1,:))/(2*delta);
        end
    end
end

%% Function to Calculate Range
function range = calculateRange(traj, anchors)
    range = zeros(length(traj), length(anchors));
    
    for i = 1:length(traj)
        for j = 1:length(anchors)
            % X = [traj(i,:); anchors(j,:)];
            % range(i,j) = pdist(X);
            range(i,j) = norm(traj(i,:)-anchors(j,:));
        end
    end
end

%% Function to Calculate Angle
function angle = calculateAngle(traj)
    angle = zeros(length(traj), 1);
    
    for i = 2:length(traj)
        [x1, y1, x2, y2] = deal(traj(i-1,1), traj(i-1,2), traj(i,1), traj(i,2));
        angle(i) = atan2(y2 - y1, x2 - x1);
    end
end

%% Function to Generate a Spiral Trajectory and Randomly Place Anchors
function [trajectory, anchorPositions] = generateSpiralTrajectory(x_min, x_max, y_min, y_max, num_points)
    theta = linspace(0, 4*pi, num_points); % Angle for the spiral
    r = linspace(0, 10, num_points); % Radius for the spiral
    
    % Generate spiral trajectory within the bounding box
    traj_x = x_min + (x_max - x_min) * (0.5 + r .* cos(theta) / max(r));
    traj_y = y_min+ (y_max - y_min) * (0.5 + r .* sin(theta) / max(r));
    
    % Create the trajectory matrix
    trajectory = [traj_x', traj_y'];
    
    % Number of anchors and their positions
    num_anchors = 5;  % Adjust as needed
    anchors_x = x_min + (x_max - x_min) * rand(1, num_anchors);
    anchors_y = y_min + (y_max - y_min) * rand(1, num_anchors);
    anchorPositions = [anchors_x', anchors_y'];
end
%% Function to Plot the Trajectory and Anchors
function plotTrajectoryAndAnchors(traj, anchors)
    figure;
    plot(traj(:,1), traj(:,2), 'b-', 'LineWidth', 2);
    hold on;
    plot(anchors(:,1), anchors(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    title('Simulated 2D Trajectory and Anchors', 'Interpreter', 'latex');
    xlabel('X Coordinate (m)', 'Interpreter', 'latex');
    ylabel('Y Coordinate (m)','Interpreter', 'latex');
    legend('Simulated Trajectory', 'Anchors','Interpreter', 'latex');
    axis equal;
    grid on;
end
