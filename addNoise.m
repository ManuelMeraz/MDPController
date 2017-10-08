function [thetaN,thetadotN] = addNoise(theta,thetadot,mu,sigma)
    %v1 = randomN(sigma(1,1)) + mu;
    %v2 = randomN(sigma(2,2)) + mu;

    v = normrnd(mu, sigma(1, 1));
    thetaN = theta + v;

    v = normrnd(mu, sigma(2, 2));
    thetadotN = thetadot + v;
end
