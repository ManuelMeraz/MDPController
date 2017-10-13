function startSimulation(sim, params, noise, Policy, S)

    % Plot settings
    graphics_toolkit('fltk')
    handle = figure('Position',[0,0,1300,700]);

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

    t = 2;
    while t < interval && !FAIL && ishandle(handle)

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

        % Update data for plot
        data = [data; [theta, thetaDot, getReward(params, s)]];

        if t - 100 < 0 
            leftBoundPlot = sim.thetaNaught;
        else
            leftBoundPlot =  t - 100;
        end

        % Plot settings
        plot(data);
        set(findall(gca, 'Type', 'Line'), "linewidth", 1)
        title("Inverted Pendulum controlled with MDP");
        legend('Theta', 'ThetaDot', 'Reward');
        axis([leftBoundPlot , t]);
        grid
        drawnow;
        pause(0.0001);


        % Discretized theta and thetaDot
        sPrime = mapToDiscreteValue(S, [theta;thetaDot]);

        u = getActionFromPolicy(Policy, sPrime);

        ++t;

    end

    meanTheta /= interval;

    % Show the policy used
    Policy

    if FAIL 

        fprintf('Pendulum went out of bounds! Pendulum went out of bounds after %d iterations!\n\n\n', t)
    else
        fprintf('Pendulum ran beautifully for %d iterations! \n\n\n', t)
    end

    fprintf('Max Theta: %d\nMin Theta: %d\nMax ThetaDot: %d\nMin ThetaDot: %d\nMean Theta: %d\n',...
    maxTheta, minTheta, maxThetaDot, minThetaDot, meanTheta)

    fprintf('\n\n\n')


end
