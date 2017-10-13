function startSimulation(sim, params, noise, Policy, S)

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

end
