function Policy = MDP(state, noise, S, vS, A, dt)
    % Returns the optimal policy of inverted pendulum 
    % with given a set of states S, possible actions A
    % O(A * S^2)

    numStates = state.numStates;
    discount = 0.9;

    length = length(vS);
    for i = 1:length
        PercentageCompleted = i/length * 100
        s = vS(:,i);
        Policy(:,i) = s;
        bestActions(:,i) = VStar(discount, state, noise, S, vS, A, dt, vS(:,i));
    end

    Policy = [Policy; bestActions];

end

function a = VStar(discount, state, noise, S, vS, A, dt, s)
    % Given a state s, compute the expection for every action for every
    % possible future state. Return the max.

    for i = 1:length(A)

        % Commit to action a
        a = A(1, i);
        R(1,i) = a;
        R(2,i) = 0;
        depth = 0;

        % Compute the next state for the given 
        sPrime = simulateOneStep(s(1,1), s(2,1), dt, a);
        T = transitionProbabilities(S, sPrime, state, noise);
        sPrime = mapToDiscreteValue(S, sPrime);
        for j = 1:length(vS)

            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);

            % Bellman Equation. Sum of future rewards
            futureRewards = psPrime * (getReward(state, sPrime) + ...
            discount * QStar(depth + 1, discount, state, noise, S, vS, A, dt, sPrime));
            R(2, i) += futureRewards;
        end
    end

    a = R(1,1);
    reward = R(2,1);
    maxIndex = 1;
    for i = 2:length(R)
        if R(2,i) > R(2, maxIndex)
            reward = R(2,i);
            a = R(1,i);
            maxIndex = i;
        end
    end
end



function r = QStar(depth, discount, state, noise, S, vS, A, dt, s)
    % Given a state and action compute the sum of the rewards
    % for all future states
    r = 0;
    if depth >= state.depthLimit
        return;
    end

    for i = 1:length(A)
        a = A(1, i);
        sPrime = simulateOneStep(s(1,1), s(2,1), dt, a);
        T = transitionProbabilities(S, sPrime, state, noise);
        sPrime = mapToDiscreteValue(S, sPrime);

        for j = 1:length(vS)
            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);
            %Bellman Equation. Sum of future rewards
            r += psPrime * (getReward(state, sPrime) + ...
            discount * QStar(depth + 1, discount, state, noise, S, vS, A, dt, sPrime));
        end
    end
end

function ps = getTransitionProbability(T, S, sPrime) 
   % Given a state and transition matrix, return the transition probability
   % for that state 

   for i = 1:length(S)
       if sPrime(1,1) == S(1,i) && sPrime(2,1) == S(2,i)
           index = i;
           theta = sPrime(1,1);
           thetaDot = sPrime(2,1);
           ps = T(1,i) * T(2,i);
       end
   end

end
