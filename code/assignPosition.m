function [xVect, yVect] = assignPosition(xBound, yBound, numE)
%assignPosition generates random x and y coordinates
%   assignPosition(xBound, yBound, numE)
%   Inputs:
%       xBound - Maximum x value allowed by the system
%       yBound - Maximum y value allowed by the system
%       numE   - Number of electrons being simulated
%   Outpus:
%       xVect  - Vector of x values of length numE
%       yVect  - Vector of y values of length numE

xVect = rand(numE, 1)*xBound;
yVect = rand(numE, 1)*yBound;

end

