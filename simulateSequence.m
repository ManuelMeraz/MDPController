function [thetaN,thetadotN] = simulateSequence(theta,thetadot,u,deltaT,mu,sigma)
    thetaN = theta;
    thetadotN = thetadot;

    for i = 1: length(u),
        [thetaN, thetadotN] = simulateOneStep(thetaN, thetadot, deltaT, u(i));
        [thetaN, thetadotN] = addNoise(thetaN, thetadotN, mu, sigma)
end
