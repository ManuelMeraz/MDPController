% Manuel Meraz
% EECS 270 Robot Algorithms
% Makov Decision Processes Controller for Simple Inverted Pendulum

% If previous policy has been generated, load it from the Policies.mat file
try
    Policies = load('Policies.mat', 'Policies').Policies;
catch
    'File does not exist'
end


% params is a struct containing all MDP params
% setPoint is the angle  you want the inverted pendulum to stay balanced at
params.setPoint = 0;

% depth of recursion tree
params.depthLimit = 1; % Stop it at a low depth for faster computation
params.stateBounds = [params.setPoint-pi/4, params.setPoint+pi/4; -5, 5];
params.numStates = 5; % Low states faster to compute and works good enough
params.discount = 0.95; % High discount means future rewards matter more

% Time step size
params.dt = 0.1; % Seconds

% Number of dimensions state vector is in
params.dimensions = 2; % Don't modify this. 

% Noise contains all noise params
noise.mu = zeros(params.dimensions, 1);
noise.covariance = [0.01, 0; 0, 0.001];

% Calculates the step size between each upper and lower bound
for d = 1:params.dimensions
    % Step size is (outer bound - inner bound) / number of states
    params.stepSize(d, 1) = (...
    (params.stateBounds(d, 2) - params.stateBounds(d, 1))/...
    params.numStates);
end

% Simulation Parameters
sim.interval = 500;
sim.thetaNaught = params.setPoint; % Center it around the setPoint
sim.thetaDotNaught = 0; % Start sim standing still

% difference from setpoint where sim will cause policy to fail
% Larger values will give more wiggle room 
sim.fail.upperBound = params.setPoint + pi/4;
sim.fail.lowerBound = params.setPoint - pi/4;

% Will add noise to sim if true, false will show no noise
sim.addNoise = true;


% Set of actions
% Higher resolution action set helps improve balancing
A = [-100:100];

% Set of states. [theta1 theta2 ... thetan;thetaDot1 thetaDot2 .... thetaDotn]
S = [linspace(params.stateBounds(1,1), params.stateBounds(1,2), params.numStates);...
linspace(params.stateBounds(2,1), params.stateBounds(2,2), params.numStates)];

try
    Policy = Policies{params.numStates};
    Policy(1,1); % Check to see if it's not empty
catch
    'Policy does not exist. Generating one for the number of states'
    % Policy is of length numStates and contains the optimal action a 
    % in the corresponding column of state s in the set S
    Policy = MDP(params, noise, S, A);

    Policies{params.numStates} = Policy;
    save('Policies.mat', 'Policies');
end

% Iniital Simulation Parameters
theta = sim.thetaNaught;
thetaDot = sim.thetaDotNaught;
interval = sim.interval;

% Make sure state is a discretized value within policy 
s = mapToDiscreteValue(S, [theta;thetaDot]);
u = getActionFromPolicy(Policy, s);

% Data for plot
data(1,1) = theta;
data(1,2) = thetaDot;
data(1,3) = getReward(params, s);

% Keep track of statistics
maxThetaDot = minThetaDot = thetaDot;
meanTheta = maxTheta = minTheta = theta;

% When pendulum goes out of bounds, this will be true
FAIL = false;
lowerBound = sim.fail.lowerBound;
upperBound = sim.fail.upperBound;

for i = 2:interval

    % Real value given by math model
    sPrime = simulateOneStep(theta, thetaDot, params.dt, u);
    theta = sPrime(1,1);

    if sim.addNoise == true
        theta += normrnd(noise.mu(1,1),noise.covariance(1,1));
    end

    meanTheta += theta;

    % Avquire max and min theta
    if theta > maxTheta
        maxTheta = theta;
    end

    if theta < minTheta
        minTheta = theta;
    end

    if theta < lowerBound || theta > upperBound
        FAIL = true;
        break;
    end

    thetaDot = sPrime(2,1);
    if sim.addNoise == true
        thetaDot += normrnd(noise.mu(2,1),noise.covariance(2,2));
    end

    % Acquire max and min thetaDot
    if thetaDot > maxThetaDot
        maxThetaDot = thetaDot;
    end

    if thetaDot < minThetaDot
        minThetaDot = thetaDot;
    end

    data (i,1) = theta;
    data(i,2) = thetaDot;
    data(i, 3) = getReward(params, [theta;thetaDot]);

    % Discretized theta and thetaDot
    sPrime = mapToDiscreteValue(S, [theta;thetaDot]);

    u = getActionFromPolicy(Policy, sPrime);
    %data(i,3) = u;
end

meanTheta /= interval;

% Show the policy used
Policy

if FAIL 

    fprintf('Pendulum went out of bounds! Pendulum went out of bounds after %d iterations!\n\n\n', i)
else
    fprintf('Pendulum ran beautifully for %d iterations! \n\n\n', i)
end

fprintf('Max Theta: %d\nMin Theta: %d\nMax ThetaDot: %d\nMin ThetaDot: %d\nMean Theta: %d\n',...
maxTheta, minTheta, maxThetaDot, minThetaDot, meanTheta)

fprintf('\n\n\n')

figure('Position',[0,0,1300,700]);
plot(data, 'linewidth', 1);
set(gca, "linewidth", 4, "fontsize", 12)
title("Inverted Pendulum controlled with MDP");
%legend('Theta', 'ThetaDot', 'Force', 'Reward');
legend('Theta', 'ThetaDot', 'Reward');
%legend('Theta');
pause();

