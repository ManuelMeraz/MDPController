function [S, A, T, R]  = initializeMDP(stateParams, U)

    numStates = stateParams.numStates
    thetaMin = stateParams.thetaBounds(1,1)
    thetaMax = stateParams.thetaBounds(1,2)
    thetaDotMin = stateParams.thetaDotBounds(1,1)
    thetaDotMax = stateParams.thetaDotBounds(1,2)
    [~,numActions] = size(U)

    [thetaStates, thetaDotStates] = ngrid(...
    linspace(thetaMin, thetaMax, numStates),...
    linspace(thetaDotMin, thetaDotMax, numStates));

    numel(thetaStates)
    reshape(thetaStates, 1, numel(thetaStates))

    S = A = T = R = [];

end
