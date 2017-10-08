deltaT = 0.1; % Seconds
maxIterations = 500;

dimensions = 2;

noise.mu = zeros(dimensions, 1);
noise.covariance = eye(dimensions) * 0.1;

state.stateBounds = [-pi/4, pi/4; -1, 1];
state.numStates = 3;

for dimension = 1:dimensions
    % Step size is (outer bound - inner bound) / number of states
    state.stepSize(dimension, 1) = (...
    (state.stateBounds(dimension, 2) - state.stateBounds(dimension, 1))/...
    state.numStates);
end


A = [-2, -1, 0, 1, 2]; % set of actions


S = [linspace(-pi/4, pi/4, state.numStates); linspace(-1, 1, state.numStates)]
sPrime = [pi/4; 1]

transitionProbabilities(S, sPrime, state, noise)

%[S, A, T, R] = initializeMDP(state, A, deltaT);

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
