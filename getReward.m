function r = getReward(s)
    theta = s(1,1);
    thetaDot = s(2,1);
    r = 0;

    if abs(theta) > pi/4
        r = -3;
    elseif abs(theta) > pi/5
        r = -2;
    elseif abs(theta) > pi/6
        r = -1;
    else
        r = 1;
    end

    if thetaDot < 0 && thetaDot > 0
        r += 1
        
    if theta <= 0.1 &&  theta >= -0.1
        r *= 3;
    end
     
end
