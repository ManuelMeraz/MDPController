% Time step size
dt = 0.1; % Seconds
maxIterations = 100;

% Number of dimensions state vector is in
dimensions = 2;

% Noise contains all noise parameters
noise.mu = zeros(dimensions, 1);
noise.covariance = eye(dimensions) * 0.1;

% State is a struct containing all state parameters
state.stateBounds = [-pi/4, pi/4; -1, 1];
state.numStates = 10;

% Calculates the step size between each upper and lower bound
for dimension = 1:dimensions
    % Step size is (outer bound - inner bound) / number of states
    state.stepSize(dimension, 1) = (...
    (state.stateBounds(dimension, 2) - state.stateBounds(dimension, 1))/...
    state.numStates);
end

% Set of actions
A = [-2, -1, 0, 1, 2];

% Set of states
S = [linspace(-pi/4, pi/4, state.numStates); linspace(-1, 1, state.numStates)];

% Policy is of length numStates and contains the optimal action a 
% in the corresponding column of state s in the set S
Policy = MDP(state, noise, S, A, dt, dimensions)

theta = 30;
thetaDot = 0;
data(1,1) = theta;
data(1,2) = thetaDot;
data(1,3) = getReward([theta;thetaDot]);

%u = 6.6345;

for i = 1:length(Policy)
    if theta == Policy(1,i) && thetaDot
u = 
deltaT = 0.1;

%for i = 2:maxIterations
    %data(i, 3) = getReward([theta;thetaDot]);
    %sPrime = simulateOneStep(theta, thetaDot, deltaT, u);
    %theta = sPrime(1,1);
    %thetaDot = sPrime(2,1);
    %data (i,1) = theta;
    %data(i,2) = thetaDot;
%end

%data

%setenv("GNUTERM","qt");
%figure('Position',[0,0,1300,700]);
%h = plot(data, 'linewidth', 2);
%set(gca, "linewidth", 4, "fontsize", 12)
%title("Inverted Pendulum controlled with MDP");
%legend('Theta', 'ThetaDot', 'Reward');
%pause();
