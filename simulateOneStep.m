function sPrime = simulateOneStep(theta,thetaDot,deltaT,u)
    J =  m = l = 1;
    gamma = 0.1;
    g = 9.81;
    Jt = J + m * l ^ 2;

    % TODO remove this final result
    %if(theta > 0)
        %u = -u;
    %end

    angularAcceleration = m * g * l * sin(theta) / Jt - (gamma * thetaDot)/ Jt + (l / Jt) * cos(theta) * u;

    thetadotN = thetaDot + deltaT * angularAcceleration; % v = v_0 + angularAccerlation * t
    thetaN = theta + thetadotN * deltaT;

    % Make sure theta stays within allowable range
    while thetaN > 3.14
        thetaN -= 2 * 3.14;
    end

    while thetaN < - 3.14
        thetaN += 2 * 3.14;
    end

    sPrime = [thetaN; thetadotN];

end
