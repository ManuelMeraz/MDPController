function [S, A, T, R]  = initializeMDP(stateParams, A, deltaT)
    % O(A * S^2)

    numStates = stateParams.numStates;
    thetaMin = stateParams.thetaBounds(1,1);
    thetaMax = stateParams.thetaBounds(1,2);
    thetaDotMin = stateParams.thetaDotBounds(1,1);
    thetaDotMax = stateParams.thetaDotBounds(1,2);
    numActions = length(A);

    [thetaStates, thetaDotStates] = meshgrid(...
    linspace(thetaMin, thetaMax, numStates),...
    linspace(thetaDotMin, thetaDotMax, numStates));

    % Number of elements in an nxn matrix
    numElements = numStates^2;

    % All possible combinations of 2 dimensional state 
    % represented by each column vector
    S = [reshape(thetaStates, [], numElements);...
    reshape(thetaDotStates, [], numElements)]

    numStateCombinations = length(S)

    % Generate a transition matrix for every action leading to every state
    % Column = [theta; thetaDot; T(s, a, s')]
    T = zeros(3, numStateCombinations, numActions)

    %for action = 1:numActions
        
        

    S = A = T = R = [];
end
