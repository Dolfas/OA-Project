%% Main for task 9
clc;
clear;
% Define the bounding box
x_lim = [-20, 20];
y_lim = [-25,25];

% User defines created trajectory
traj = input("Press 1 for 'pear' shaped trajectory or 2 for spiral trajectory.\n");
[xgt, orient,v,acc,angvel, a, tref] = create_trajectory(traj);

% Since waypointTrajectory() function returns velocity and orientation at
% each point, only r will be usefull
[simulated_velocity, r, angle] = simulateData(xgt, a);

if traj == 1
    save('pear_t9.mat','xgt' ,'v','r', 'a', 'angle', 'tref'); %save generated data in file
elseif traj == 2
    save('spiral_t9.mat','xgt' ,'v','r', 'a', 'angle', 'tref'); 
end
%plot trajectory and anchors
plotTrajectoryAndAnchors(xgt, a, x_lim,y_lim);
%% Create trajectory
function [xgt, orient,v,acc,angvel, a, tref] = create_trajectory(traj)
SR = 2;
    if traj == 1
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
        time = 0:1/SR:(length(xgt)-1)*(1/SR); %time at each point
        tref = time';

    elseif traj == 2
        a = [-19,-19; 19,-19; -19, 19; 19,19]; %position of anchors
        waypoints = [15 0 0;0 15 0;-15 0 0;0 -15 0;10 0 0;0 10 0; -10 0 0;
            0 -10 0;5 0 0;0 5 0;-5 0 0;0 -5 0;2.5 0 0;0 2.5 0;-2.5 0 0]; %defining points
        vel = [0 1 0;-1 0 0;0 -1 0;1 0 0;0 1 0;-1 0 0;0 -1 0;
            1 0 0;0 1 0;-1 0 0;0 -1 0;1 0 0;0 1 0;-1 0 0;0 -1 0]; %velocity values in such points
        t_arrival = cumsum([0 4 4 4 4 3 3 3 3 3 3 3 3 3 3]'); %time at such points
        orient = [90 0 0;180 0 0;90 0 0;180 0 0;90 0 0;180 0 0;90 0 0;
            180 0 0;90 0 0;180 0 0;90 0 0;180 0 0;90 0 0;180 0 0;90 0 0];%angle orientation at such points
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
        time = 0:1/SR:(length(xgt)-1)*(1/SR); %time at each point
        tref = time';
    else
        fprintf('Invalid input.\n')
    end    
end
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
%% Function to Plot the Trajectory and Anchors
function plotTrajectoryAndAnchors(traj, anchors,x_lim,y_lim)
    figure;
    plot(traj(:,1), traj(:,2), 'b-', 'LineWidth', 2);
    hold on;
    plot(anchors(:,1), anchors(:,2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    title('\textbf{Simulated 2D Trajectory and Anchors}', 'Interpreter', 'latex');
    xlabel('\textbf{x Coordinate (m)}', 'Interpreter','latex');
    ylabel('\textbf{y Coordinate (m)}', 'Interpreter','latex');
    xlim(x_lim);
    ylim(y_lim);
    legend('Simulated Trajectory', 'Anchors','Interpreter', 'latex');
    axis equal;
    grid on;
end