function [xVelocity,yVelocity,zVelocity] = assignVelocity(totalV, numE, numDimensions)
%assignVelocity Assigns random component velocities given a vector total
%   assignVelocity(totalV, numE, numDimensions)
%   Inpus:
%       totalV        - Magnitude of velocity
%       numE   - Number of electrons being simulated
%       numDimensions - Number of output vectors for 1D, 2D, 3D
%   Outpus:
%       xVelocity  - Vector of x-component velocities
%       yVelocity  - Vector of y-component velocities
%       zVelocity  - Vector of z-component velocities

%Ignore 1 and 3D cases for now

%Generate vector of angles, then use angle to find component of x and y
angleVect = rand(numE, 1)*2*pi;
xVelocity = totalV*cos(angleVect);
yVelocity = totalV*sin(angleVect);
zVelocity = [];


end

