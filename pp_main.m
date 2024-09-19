%% TRAJECTORY COMPUTATION

clear all
close all

openfig("warehouse.fig");
paths = {};
paths = load("C:\Users\Luca\Desktop\Collaborative path\paths_registration.mat").paths_registration;

global nRobots;
nRobots = size(paths,2);

for j=1:nRobots
    paths{j} = unique(paths{j},'rows','stable');
end

%% VARIABLES
robotSize = 20;
collisionThreshold = 20;
maxVelocity = 20;

animation = true;
animVelocity = 7;
recordAnimation = true;
solveCollisions = true;

global samplingTime;
samplingTime = 0.1;

% Create random path colors
global pathColors;
pathColors = distinguishable_colors(nRobots);



%% GET THE LONGEST PATH and ITS FINISH TIME
distances = [];
for j=1:nRobots

        % Calculate paths' distances
        totalDistance = 0;
        for i=2:size(paths{j},1)
            segmentDistance = norm(paths{j}(i-1,:)-paths{j}(i,:));
            totalDistance = totalDistance + segmentDistance;
        end

        distances = [distances, totalDistance];

end

maxDistanceIndex = find(distances==max(distances));
firstTrajectory = pp_interpolatePath(paths{maxDistanceIndex},maxVelocity,0,0);
tmax = firstTrajectory.t_tot(end);

%% PLAN THE VECTOR OF MAX VELOCITIES ACCORDINGLY

maxVelocities = zeros(1,nRobots);
for j=1:nRobots

        if j==maxDistanceIndex
            maxVelocities(j) = maxVelocity;
        else
            maxVelocities(j) = distances(j)/tmax;
        end

end

maxVelocities

%% INTERPOLATION
trajectories = {};
for j=1:nRobots
    trajectories{j} = pp_interpolatePath(paths{j},maxVelocities(j),0,0);
end

% Plot the trajectories
pp_plotPathOnMap(paths,trajectories,'-');

% Plot positions, velocities and accelerations
pp_producePlots(trajectories);
pp_computeVelocityOverTime(trajectories{1}.x_tot,trajectories{1}.y_tot,trajectories{1}.t_tot)

%% COLLISION CHECKING
collisions = {};
for j=1:nRobots
    collisions{j} = pp_checkCollisionForOneRobot(paths,trajectories,collisionThreshold,j);
end

% Plot collisions
if ~solveCollisions
    pp_plotCollisions(collisions,trajectories);
end

finishTimes = [];
for j=1:nRobots
    finishTimes = [finishTimes, trajectories{j}.t_tot(end)];
end
finishTimes

figure(1)
%% COLLISION SOLVING
if ~isempty(collisions) && solveCollisions
    
    [collisions, trajectories] = pp_getCollisionFreeTrajectories(paths,trajectories,maxVelocities,collisions,collisionThreshold);
    
end

finishTimes = [];
for j=1:nRobots
    finishTimes = [finishTimes, trajectories{j}.t_tot(end)];
end
finishTimes

pp_plotPathOnMap(paths,trajectories,'-');

%% ANIMATION
if animation
    fprintf("\nPress enter to record animation with velocity %dx...\n",animVelocity);
    pp_animateTrajectory(trajectories,robotSize,recordAnimation,animVelocity);
end

figure(1)
saveas(gcf,'warehouse.png')