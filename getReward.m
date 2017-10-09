function r = getReward(s)
    theta = s(1,1);
    thetaDot = s(2,1);

    r = abs(theta)^(-1) - (theta * thetaDot);

    if r == inf || r > 2
        r = 2;

    if theta == 0 && thetaDot == 0
        r *= 2;
    elseif theta == 0
        r *= 1.4;
    end
     
end
