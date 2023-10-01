%% Inicializations

x = linspace(-20,20);
y = linspace(-20,20);

traj = readmatrix('trial_3.txt');
anchors = readmatrix('anchors.txt');

rate = 1/2;
%% Data simulation
v = zeros(length(traj),2);
for i = 1:length(traj)

    if i == 1 %First point do forward difference
        v(i,1) = (traj(i+1,1)-traj(i,1))/rate;
        v(i,2)= (traj(i+1,1)-traj(i,1))/rate;

    elseif i == length(traj) %Last point do backward difference
        v(i,1) = (traj(i,1)-traj(i-1,1))/rate;
        v(i,2)= (traj(i,1)-traj(i-1,1))/rate;

    else %The rest do symmetrical difference 
        v(i,1) = (traj(i+1,1)-traj(i-1,1))/(2*rate);
        v(i,2)= (traj(i+1,1)-traj(i-1,1))/(2*rate);
    end
end
