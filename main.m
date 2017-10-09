try
    Policies = load('Policies.mat', 'Policies').Policies;
catch
    'File does not exist'
end

% Time step size
dt = 0.1; % Seconds
maxIterations = 1000;

% Number of dimensions state vector is in
dimensions = 2;

% Noise contains all noise parameters
noise.mu = zeros(dimensions, 1);
noise.covariance = eye(dimensions) * 0.1;

% State is a struct containing all state parameters
state.stateBounds = [-pi/4, pi/4; -1, 1];
state.numStates = 3;


% Calculates the step size between each upper and lower bound
for dimension = 1:dimensions
    % Step size is (outer bound - inner bound) / number of states
    state.stepSize(dimension, 1) = (...
    (state.stateBounds(dimension, 2) - state.stateBounds(dimension, 1))/...
    state.numStates);
end

% Set of actions
A = [-100, -10, -2, 0, 2, 10, 100];

% Set of states
S = [linspace(-pi/4, pi/4, state.numStates); linspace(-5, 5, state.numStates)];

% Generate all possible state vectors
[Thetas, ThetaDots] = meshgrid(S(1,:), S(2,:));
vS = [reshape(Thetas, 1, numel(Thetas)); reshape(ThetaDots, 1, numel(ThetaDots))];

try
    Policy = Policies{state.numStates};
catch
    'Policy does not exist. Generating one for the number of states'
    % Policy is of length numStates and contains the optimal action a 
    % in the corresponding column of state s in the set S
    Policy = MDP(state, noise, S, vS, A, dt, dimensions);

    Policies{state.numStates} = Policy;
    save('Policies.mat', 'Policies');

end

theta = 0.0001;
thetaDot = 0;
data(1,1) = theta;
%data(1,2) = thetaDot;
%data(1,3) = getReward([theta;thetaDot]);

s = mapToDiscreteValue(S, [theta;thetaDot]);
e = 0.00001;
for i = 1:length(Policy)
    if s(1,1) <= Policy(1,i)+e && s(1,1) >= Policy(1,i)-e ...
       && s(2,1) <= Policy(2,i)+e && s(2,1) >= Policy(2,i)-e 

        u = Policy(3, i);
        %data(1,3) = u;
        break;
    end
end

for i = 2:maxIterations
    sPrime = simulateOneStep(theta, thetaDot, dt, u);
    theta = sPrime(1,1);
    thetaDot = sPrime(2,1);
    data (i,1) = theta;
    %data(i,2) = thetaDot;
    %data(i, 3) = getReward([theta;thetaDot]);

    sPrime = mapToDiscreteValue(S, [theta;thetaDot]);
    thetaD = sPrime(1,1);
    thetaDotD = sPrime(2,1);

    for j = 1:length(Policy)
        if thetaD <= Policy(1,j)+e && thetaD >= Policy(1,j)-e ...
           && thetaDotD<= Policy(2,j)+e && thetaDotD >= Policy(2,j)-e 
            u = Policy(3, j);
            %data(i,3) = u;
            break;
        end
    end
end

setenv("GNUTERM","qt");
figure('Position',[0,0,1300,700]);
h = plot(data, 'linewidth', 1);
set(gca, "linewidth", 4, "fontsize", 12)
title("Inverted Pendulum controlled with MDP");
%legend('Theta', 'ThetaDot', 'Force', 'Reward');
%legend('Theta', 'ThetaDot', 'Reward');
legend('Theta');
pause();
