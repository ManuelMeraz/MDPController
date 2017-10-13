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
sim.interval = 10000;
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

% All plotting handled in here
startSimulation(sim, params, noise, Policy, S);

