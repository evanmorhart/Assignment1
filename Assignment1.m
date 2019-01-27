function Assignment1(numOfParticles)
%Assignment1 Submission for Assignment1 of ELEC 4700
%   Models the behaviour of interacting electrons using Monte-Carlo
%   methods.

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

system.thermalV = sqrt(c.boltzmann.*system.Temp./(electron.effM));

system.meanFreePath = system.thermalV.*system.Tau;



electron.x = rand(1, numOfParticles).*system.x;
electron.y = rand(1, numOfParticles).*system.y;





end

