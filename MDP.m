function Policy = MDP(params, noise, S, A)
    % Returns the optimal policy of inverted pendulum 
    % with given a set of states S, possible actions A
    % O(A * S^2)

    % Generate all possible state vectors
    % e.g. [theta1 theta1 theta2 theta2; thetaDot1 thetaDot2 thetaDot1 thetadot2]
    [Thetas, ThetaDots] = meshgrid(S(1,:), S(2,:));
    vS = [reshape(Thetas, 1, numel(Thetas)); reshape(ThetaDots, 1, numel(ThetaDots))];

    numStates = params.numStates;
    discount = params.discount;
    dt = params.dt;

    totalStates = length(vS);
    for i = 1:totalStates
        PercentageCompleted = i/totalStates * 100
        s = vS(:,i);
        Policy(:,i) = s;
        bestActions(:,i) = VStar(discount, params, noise, S, vS, A, dt, vS(:,i));
    end

    Policy = [Policy; bestActions];

end

function a = VStar(discount, params, noise, S, vS, A, dt, s)
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
        T = transitionProbabilities(S, sPrime, params, noise);
        for j = 1:length(vS)

            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);

            % Bellman Equation. Sum of future rewards
            futureRewards = psPrime * (getReward(params, sPrime) + ...
            discount * QStar(depth + 1, discount, params, noise, S, vS, A, dt, sPrime));
            R(2, i) = R(2,i) +  futureRewards;
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



function r = QStar(depth, discount, params, noise, S, vS, A, dt, s)
    % Given a state and action compute the sum of the rewards
    % for all future states
    r = 0;
    if depth >= params.depthLimit
        return;
    end

    for i = 1:length(A)
        a = A(1, i);
        sPrime = simulateOneStep(s(1,1), s(2,1), dt, a);
        T = transitionProbabilities(S, sPrime, params, noise);

        for j = 1:length(vS)
            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);
            %Bellman Equation. Sum of future rewards
            r = r +  psPrime * (getReward(params, sPrime) + ...
            discount * QStar(depth + 1, discount, params, noise, S, vS, A, dt, sPrime));
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
