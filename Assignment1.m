function Assignment1(numOfParticles, numLoops)
%Assignment1 Submission for Assignment1 of ELEC 4700
%   Models the behaviour of interacting electrons using Monte-Carlo
%   methods.

%Add the code directory to the matlab path to get access for the rest of
%the script
addpath(strcat(fileparts(mfilename('fullpath')), '\code'));

%Universal constants
c.eRestMass = 9.109E-31; %kg
c.boltzmann = 1.381E-23; %J/K

%Setup data structures
system.x = 200E-9; %m
system.y = 100E-9; %m
system.Temp = 300; %K
system.Tau = 0.2E-12; %s

electron.effM = 0.26.*c.eRestMass;
electron.num = numOfParticles;
electron.x = zeros(1,numOfParticles);
electron.y = zeros(1,numOfParticles);
electron.vx = zeros(1, numOfParticles);
electron.vy = zeros(1, numOfParticles);


%Calculation for thermal velocity and mean free path
system.thermalV = sqrt(2.*c.boltzmann.*system.Temp./(electron.effM));
system.meanFreePath = system.thermalV.*system.Tau;

[electron.x, electron.y] = assignPosition(system.x, system.y, electron.num);

%Generate the time step as time it takes to travel 150th
%of the minimum dimension at speed of thermal velocity
timeStep = min([system.x system.y])./(100.*system.thermalV);

figure(1);
xlim([0 system.x]);
ylim([0 system.y]);

hold on


%Uncomment to run different parts of assignment
noCollision(system, electron, numLoops, timeStep);
%meanFreePath(system,electron, numLoops, timeStep);
%bottleNeck(system, electron, numLoops, timeStep, 'specular');

end
