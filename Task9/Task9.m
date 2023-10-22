%% Main Script

% Define the bounding box
x_lim = [-20, 20];
y_lim = [-20,20];

% Trajectory creation
SR = 2;  % Frequency of samples
a = [-19,-19; 19,-19; -19, 19; 19,19]; %position of anchors
waypoints = [3 3 0;-4 13 0;-4 -16 0;12 -13 0;3 3 0]; %defining points
vel = [0 1 0;-1 0 0;1 0 0;1 0 0;0 1 0]; %velocity values in such points
t_arrival = cumsum([0 5 8 10 12]'); %time at such points
orient = [90 0 0;180 0 0;0 0 0;0 0 0;90 0 0];%angle orientation at such points
quants = quaternion(orient,"eulerd","ZYX","frame"); %transforming in quarternion
trajectory = waypointTrajectory( ...
    waypoints, SampleRate = SR, Velocities = vel, ...
    TimeOfArrival = t_arrival, Orientation = quants);

[xgt, orient, v, acc, angvel] = trajectory();
i = 1;
spf = trajectory.SamplesPerFrame;

while ~isDone(trajectory) %Creating trajectory points
    idx = (i+1):(i+spf);
    [xgt(idx,:), orient(idx,:), v(idx,:), angvel(idx,:)] = trajectory();
    i = i + spf;
end
xgt(:,3) = []; %Drop z collumn
v(:,3) = []; %Drop z collumn
tref = 0:1/SR:length(xgt); %time at each point

%Spiral
%[traj, anchors] = generateSpiralTrajectory(x_min, x_max, y_min, y_max, T);

[simulated_velocity, r, angle] = simulateData(xgt, a);

save('traj1.mat','xgt' ,'v','r', 'a', 'angle', 'tref'); %save generated data in file

plotTrajectoryAndAnchors(xgt, a, x_lim,y_lim);
%% Function to Simulate Velocity, Range, and Angle
function [simulated_velocity, range, angle] = simulateData(traj, anchors)
    % Constants and parameters
    sampling_rate = 2;  % Sampling rate (Hz)DUVIDA SOBRE ISTO
    delta = 1 / sampling_rate; 
    
    % Calculate simulated velocity
    simulated_velocity = calculateVelocity(traj, delta);
    
    % Calculate range at each point
    range = calculateRange(traj, anchors);
    
    % Calculate angle at each point
    angle = calculateAngle(traj);
end

%% Function to Calculate Simulated Velocity
function simulated_velocity = calculateVelocity(traj, delta)
    simulated_velocity = zeros(length(traj), 2);
    
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
function plotTrajectoryAndAnchors(traj, anchors,x_lim,y_lim)
    figure;
    plot(traj(:,1), traj(:,2), 'b-', 'LineWidth', 2);
    hold on;
    plot(anchors(:,1), anchors(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    title('Simulated 2D Trajectory and Anchors', 'Interpreter', 'latex');
    xlabel('X Coordinate (m)', 'Interpreter', 'latex');
    ylabel('Y Coordinate (m)','Interpreter', 'latex');
    xlim(x_lim);
    ylim(y_lim);
    legend('Simulated Trajectory', 'Anchors','Interpreter', 'latex');
    axis equal;
    grid on;
end
