function sPrime = simulateOneStep(theta,thetaDot,deltaT,u)
    J = 1;
    m = 1;
    l = 1;
    gamma = 0.1;
    g = 9.81;
    Jt = J + m * l ^ 2;

    angularAcceleration = m * g * l * sin(theta) / Jt - (gamma * thetaDot)/ Jt + (l / Jt) * cos(theta) * u;

    thetadotN = thetaDot + deltaT * angularAcceleration; % v = v_0 + angularAccerlation * t
    thetaN = theta + thetadotN * deltaT;

    % Make sure theta stays within allowable range
    while thetaN >  3.14
        thetaN = thetaN - 2 * 3.14;
    end

    while thetaN < -  3.14
        thetaN = thetaN + 2 * 3.14;
    end

    sPrime = [thetaN; thetadotN];

end
