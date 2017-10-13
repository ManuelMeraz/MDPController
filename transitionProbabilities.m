function T = transitionProbabilities(S, sPrime, parameters, noise)
    % S is the set of discretized states
    % sPrime is the next possible state after state s and action a
    % state is the parameters for the given discrete states
    % noise is a struct containng the mean vector and covariance matrix

    % Vector of means
    mu = noise.mu;
    dimensions = length(mu);

    % Determine transition probability centered around sPrime
    for d = 1:dimensions
        mu(d, 1) = mu(d, 1) +  sPrime(d, 1);
    end

    % Covariance Matrix
    covariance = noise.covariance;

    % Number of vector states in S
    numStates = parameters.numStates;

    % Weights for Transitions 
    T = zeros(dimensions, numStates);

    % We are going to calculate the transition probability from 
    % s - deltaX to s + deltaX for every every state s within S
    deltaX = parameters.stepSize(:,1) / 2;
    for d = 1:dimensions
        T(d, 1) = T(d, 1) + getLeftProbability(S(d, 1) - deltaX(d, 1),...
        mu(d, 1), covariance(d, d));
    end


    %Every value from -inf to s1 maps to s1
    for d = 1:dimensions
        sumProb(d, 1) = T(d, 1);
        for s = 1:numStates
            % Probability from -inf to s1 + deltax
            p = getLeftProbability(S(d, s) + deltaX(d, 1), ...
            mu(d, 1), ...
            covariance(d, d));
            
            p -= sumProb(d, 1);

            % Probability from (s1 - deltax) to (s1 + deltax)
            T(d, s) = T(d, s) + p ;
            sumProb(d, 1) = sumProb(d, 1) + p;
        end
    end


    % Add in final probability to the last stte
    for d = 1:dimensions
        T(d, numStates) = T(d, numStates) + 1 - sumProb(d, 1);
        sumProb(d, 1) = sumProb(d, 1) +  1 - sumProb(d, 1);
    end

    [ThetaTransitions, ThetaDotTransitions] = meshgrid(T(1,:), T(2,:));
    T = [reshape(ThetaTransitions, 1, numel(ThetaTransitions));...
    reshape(ThetaDotTransitions, 1, numel(ThetaDotTransitions))];

end

function p = getLeftProbability(x, mu, variance)
    % Calculates the probability from -inf to x
    p = (1/2)*(1 + erf((x - mu)/sqrt(2 * variance)));
end
