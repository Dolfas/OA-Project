%% Inicializations

traj = readmatrix('trial_3.txt');
anchors = readmatrix('anchors.txt');

v_hat = zeros(length(traj),2);
range = zeros(length(traj), length(anchors)); %Each collumn represents an anchor
angle = zeros(length(traj),1);
delta = 0.01; %Time between measurements, defined in Prof's script
%% Data simulation

%Calculate vx and vy at each point
%NOTE: Might need to calculate absolute value of v... as it stands it
%doesn't
for i = 1:length(traj)

    if i == 1 %First point do forward difference
        v_hat(i,:) = (traj(i+1,:)-traj(i,:))/delta;

    elseif i == length(traj) %Last point do backward difference
        v_hat(i,:) = (traj(i,:)-traj(i-1,:))/delta;

    else %The rest do symmetrical difference 
        v_hat(i,:) = (traj(i+1,:)-traj(i-1,:))/(2*delta);
    end
end

%Calculate range at each point (?)

for i = 1:length(traj)
    for j = 1:length(anchors)

        X = [traj(i,:); anchors(j,:)]; %Group points to use function pdist
        range(i,j) = pdist(X);
    
    end
end

%Calculate angle at each point

for i = 2:length(traj) 
    %Start in two so we can calculate in every single point, including last
    [x1, y1, x2, y2] = deal(traj(i-1,1), traj(i-1,2), traj(i,1), traj(i,2));

    angle(i) = atan2(y2 - y1, x2 - x1);

end