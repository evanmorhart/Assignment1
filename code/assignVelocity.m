function [xVelocity,yVelocity,zVelocity] = assignVelocity(thermalV, systemTemp, numE, numDimensions, distribution)
%assignVelocity Assigns random component velocities given a vector total
%   assignVelocity(thermalV, systemTemp, numE, numDimensions, distribution)
%   Inpus:
%       thermalV        - Magnitude of velocity
%       systemTemp - Temperature of the system in K for mb mode
%       numE   - Number of electrons being simulated
%       numDimensions - Number of output vectors for 1D, 2D, 3D
%   Outputs:
%       xVelocity  - Vector of x-component velocities
%       yVelocity  - Vector of y-component velocities
%       zVelocity  - Vector of z-component velocities


c.boltzmann = 1.381E-23; %J/K
%Ignore 1 and 3D cases for now

%Generate vector of angles, then use angle to find component of x and y

if(strcmp(distribution, 'normal'))
    %Normally distributed  
elseif(strcmp(distribution, 'mb'))
    %Maxwell-Boltzmann
    %Using info from here:https://www.mathworks.com/help/matlab/math/random-numbers-with-specific-mean-and-variance.html
    %Assume MB is very close to normal with different std dev and mean
    stddev = sqrt(c.boltzmann.*systemTemp);
    speed = stddev.*randn(1,numE) + thermalV;
    
    angleVect = rand(1,numE).*2.*pi;
    xVelocity = speed*cos(angleVect);
    yVelocity = speed*sin(angleVect);
    zVelocity = [];
    
    histogram(speed);
else
    angleVect = rand(1,numE)*2*pi;
    xVelocity = thermalV*cos(angleVect);
    yVelocity = thermalV*sin(angleVect);
    zVelocity = [];
end

