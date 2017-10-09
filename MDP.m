function Policy = MDP(state, noise, S, A, dt)
    % Returns the optimal policy of inverted pendulum 
    % with given a set of states S, possible actions A
    % O(A * S^2)

    numStates = state.numStates;
    discount = 0.9;

    % Generate all possible state vectors
    [Thetas, ThetaDots] = meshgrid(S(1,:), S(2,:));
    vS = [reshape(Thetas, 1, numel(Thetas)); reshape(ThetaDots, 1, numel(ThetaDots))];

    for i = 1:length(vS)
       s = vS(:,i);
       Policy(:,i) = s;
       bestActions(:,i) = VStar(discount, state, noise, S, vS, A, dt, S(:,2));
    end

    Policy = [Policy; bestActions];

end

function a = VStar(discount, state, noise, S, vS, A, dt, s)
    % Given a state s, compute the expection for every action for every
    % possible future state. Return the max.

    for i = 1:length(A)

        % Commit to action a
        a = A(1, i);
        R(1, i) = a;
        R(2,i) = 0;
        depth = 0;

        % Compute the next state for the given 
        sPrime = simulateOneStep(s(1,1), s(2,1), dt, a);
        sPrime = mapToDiscreteValue(S, sPrime);
        T = transitionProbabilities(S, sPrime, state, noise);
        for j = 1:1%length(vS)
            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);
            % Bellman Equation. Sum of future rewards
            if abs(sPrime(1,1)) >= 45
                R(2,i) += psPrime * getReward(sPrime);
            else
                R(2,i)  += psPrime * (getReward(sPrime) + ...
                discount * QStar(++depth, discount, state, noise, S, vS, A, dt, sPrime));
            end
        end
    end

    a = R(1,1);
    maxIndex = 1;
    for i = 2:length(R)
        if R(2,i) > R(2, maxIndex)
            a = R(1,i);
            maxIndex = i;
        end
    end


end



function r = QStar(depth, discount, state, noise, S, vS, A, dt, s)
    % Given a state and action compute the sum of the rewards
    % for all future states
    r = 0;
    if depth >= 5
        return;
    end

    for i = 1:length(A)
        a = A(1, i);
        sPrime = simulateOneStep(s(1,1), s(2,1), dt, a);
        sPrime = mapToDiscreteValue(S, sPrime);
        T = transitionProbabilities(S, sPrime, state, noise);

        for j = 1:length(vS)
            sPrime = vS(:,j);
            psPrime = getTransitionProbability(T, vS, sPrime);
            % Bellman Equation. Sum of future rewards
            if abs(sPrime(1,1)) >= 45
                r += psPrime * getReward(sPrime);
            else
                r += psPrime * (getReward(sPrime) + ...
                discount * QStar(++depth, discount, state, noise, S, vS, A, dt, sPrime));
            end
        end
    end
end

function ps = getTransitionProbability(T, S, sPrime) 
   % Given a state and transition matrix, return the transition probability
   % for that state 

   for i = 1:length(S)
       if sPrime(1,1) == S(1,i) && sPrime(2,1) == S(2,i)
           ps = T(1,i) * T(2,i);
       end
   end

end

function sPrime = mapToDiscreteValue(S, sPrime)
    % Map the real value given to us by the pendulum dynamics function
    % to a discrete state

    theta = sPrime(1,1);
    thetaDot = sPrime(2,1);

    if theta <= S(1,1)
        theta = S(1,1);
    elseif theta >= S(1, length(S))
        theta = S(1,length(S));
    else

        for i = 1:length(S) - 1
            if theta >= S(1,i) && theta <= S(1,i + 1)
                left = theta - S(1,i);
                right = S(1,i + 1) - theta;

                if(left < right) 
                    theta = S(1,i);
                else
                    theta = S(1,i+1);
                end
                break;
            end
        end
    end

    if thetaDot <= S(2,1)
        thetaDot = S(2,1);
    elseif thetaDot >= S(2, length(S))
        thetaDot = S(2,length(S));
    else

        for i = 1:length(S) - 1
            if thetaDot >= S(2,i) && thetaDot <= S(2,i + 1)
                %left = thetaDot - S(2,i);
                %right = S(2,i + 1) - thetaDot;

                %if left < right
                    %thetaDot = S(2,i);
                %else
                    %thetaDot = S(2,i+1);
                %end
                break;
            end
        end
    end

    sPrime = [theta;thetaDot];

end
