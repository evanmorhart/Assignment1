function meanFreePath(system,electron, numLoops, timeStep)
%meanFreePath Simulates electrons moving through silicon with collision
%   meanFreePath(system,electron, numLoops, timeStep)
%   Inpus:
%       system     - Structure containing properties of silicon sample
%       electron   - Structure containing properties of electrons
%       numLoops   - Number of loops that the simulation will run for
%       timeStep   - Length of time between each plot update
%   Outputs:
%       None

c.boltzmann = 1.381E-23; %J/K
t = [0];

%Vertical vector containing time steps between each rethermalizing event
timeBetweenScatters = [];
timeTracker = zeros(1,electron.num);
%Vertical vector containing distances travelled between each rethermalizing
ditanceBetweenScatters = [];
distanceTracker = zeros(1,electron.num);

scatterCount = 0;

%Scatter probability from assignment outline
pScatter = 1 - exp(-timeStep/system.Tau);

[electron.vx, electron.vy] = assignVelocity(system, electron, 2, 'mb');

colourScheme = [0, 0.4470, 0.7410;0.8500, 0.3250, 0.0980;0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840];

for i = 1:numLoops
    
    %Same boundary conditions as noCollision
    
    currentLength = size(electron.x, 1);
    t(currentLength) = timeStep.*i;
    
    jumped(currentLength,:) = zeros(1,electron.num);
    
    for j = 1:electron.num      
        %X boundary conditions, continue through to other side
        if(electron.x(currentLength, j) < 0)
            electron.x(currentLength,j) = system.x;
            %Value has to be non-zero for find() to work
            jumped(currentLength,j) = 1;
        elseif(electron.x(currentLength,j) > system.x)
            electron.x(currentLength,j) = 0;
            %Value has to be non-zero for find() to work
            jumped(currentLength,j) = 1;
        end
        
        %Y boundary conditions, reflect, reverse y velocity
        if(electron.y(currentLength, j) < 0)
            electron.vy(currentLength,j) = -electron.vy(currentLength,j);
            electron.y(currentLength, j) = 0;
        elseif(electron.y(currentLength, j) > system.y)
            electron.vy(currentLength,j) = -electron.vy(currentLength,j);
            electron.y(currentLength, j) = system.y;
        end
        
        
        %Track changes
        timeTracker(1,j) = timeTracker(1,j) + timeStep;
        distanceTracker(1,j) = distanceTracker(1,j) + timeStep.*sqrt(electron.vx(1,j).^2+electron.vy(1,j).^2);
        
                
        %pScatter is quite small, checking for less than pScatter gives about
        %3% proability
        if(rand() < pScatter)
            scatterCount = scatterCount + 1;
            timeBetweenScatters(scatterCount,1) = timeTracker(1,j);
            distanceBetweenScatters(scatterCount,1) = distanceTracker(1,j);
            
            timeTracker(1,j) = 0;
            distanceTracker(1,j) = 0;
            
            %Rethermalize using overladed assignVelocity
            [electron.vx(currentLength,j), electron.vy(currentLength,j)] = assignVelocity(system, electron);
            
        end
    end
    
    
    
    [electron.x, electron.vx] = propagate(electron.x, electron.vx, timeStep);
    [electron.y, electron.vy] = propagate(electron.y, electron.vy, timeStep);
    

    
    
    %Plot all of the electrons if there are fewer than 7
    %Uncomment to plot during loop 
    for j = 1:min([electron.num 7])
        noLine = find(jumped(:,j),50);
        if isempty(noLine)
            %No skips, plot normally
            plot(electron.x(:,j),electron.y(:,j), 'Color', colourScheme(j,:));
        else
            plot(electron.x((1:noLine(1)-1),j),electron.y((1:noLine(1)-1),j), 'Color', colourScheme(j,:));
            for k = 1:length(noLine)         
                if k == length(noLine)
                    plot(electron.x((noLine(k):end),j),electron.y((noLine(k):end),j), 'Color', colourScheme(j,:));
                else
                    plot(electron.x((noLine(k):noLine(k+1)-1),j),electron.y((noLine(k):noLine(k+1)-1),j), 'Color', colourScheme(j,:));
                end
            end
        end
    end

    %Uncomment for temperature calculatation
    avgSpeed = mean(mean(sqrt(electron.vx.^2 + electron.vy.^2)));
    systemTemp(currentLength) = avgSpeed.^2.*electron.effM./(2.*c.boltzmann);
    
    figure(2);
    plot(t,systemTemp);
%     
     pause(0.01);
        
end




%Plotting after loop, faster
% figure(1)
% for j = 1:min([electron.num 7])
%     noLine = find(jumped(:,j),50);
%     if isempty(noLine)
%         %No skips, plot normally
%         plot(electron.x(:,j),electron.y(:,j), 'Color', colourScheme(j,:));
%     else
%         plot(electron.x((1:noLine(1)-1),j),electron.y((1:noLine(1)-1),j), 'Color', colourScheme(j,:));
%         for k = 1:length(noLine)         
%             if k == length(noLine)
%                 plot(electron.x((noLine(k):end),j),electron.y((noLine(k):end),j), 'Color', colourScheme(j,:));
%             else
%                 plot(electron.x((noLine(k):noLine(k+1)-1),j),electron.y((noLine(k):noLine(k+1)-1),j), 'Color', colourScheme(j,:));
%             end
%         end
%     end
% end

fprintf("Mean Free Path: %e \n", mean(distanceBetweenScatters));
fprintf("Mean Time Between Scatters: %e \n", mean(timeBetweenScatters));
    
end

