function r = getReward(s)
    theta = s(1,1);
    thetaDot = s(2,1);
    r = 0;

    if theta == 0
        r = 2;
    elseif theta > 0 && thetaDot < 0
        r = 1;
    elseif theta < 0 && thetaDot > 0
        r = 1;
    elseif theta > 45 || theta < -45
        r = -10;
    end
    
end
