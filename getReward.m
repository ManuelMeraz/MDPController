function r = getReward(state, s)
    theta = s(1,1);
    thetaDot = s(2,1);
    setPoint = state.setPoint;
    r = 0;

    if theta > setPoint + pi/4 || theta < setPoint - pi/4
        r = -3;
    elseif theta > setPoint + pi/5 || theta < setPoint - pi/5
        r = -2;
    elseif theta > setPoint + pi/6 || theta < setPoint - pi/5
        r = -1;
    else
        r = 1;
    end

    if theta <= setPoint + 0.1 &&  theta >= setPoint -0.1
        r *= 3;
    end
     
end
