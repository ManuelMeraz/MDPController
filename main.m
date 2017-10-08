deltaT = 0.1; % Seconds
maxIterations = 500;

stateParams.thetaBounds = (pi/4) * [-1,1];
stateParams.thetaDotBounds = [-1, 1];
stateParams.numStates = 3

U = [-2, -1, 0, 1, 2]; % set of actions

[S, A, T, R] = initializeMDP(stateParams, U);

discountFactor = 0.9; % discount 
convergance = 0.001; % stop after gamma * Q*(s) == 0.001

%theta = 0.1;
%thetaDot = 0;
%data(1,1) = theta;
%data(1,2) = thetaDot;

%u = 6.6345;
%deltaT = 0.1;

%for i = 2:maxIterations
    %[theta, thetaDot] = simulateOneStep(theta, thetaDot, deltaT, u);
    %data(i,1) = theta;
    %data(i,2) = thetaDot;
%end

%%data

%setenv("GNUTERM","qt")
%figure('Position',[0,0,1300,700]);
%plot(data)
%pause()
