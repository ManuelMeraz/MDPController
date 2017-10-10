function r = getReward(s)
    theta = s(1,1);
    thetaDot = s(2,1);
    setState = 0;
    r = 0;

    if theta > setState + pi/4 || theta < setState - pi/4
        r = -3;
    elseif theta > setState + pi/5 || theta < setState - pi/5
        r = -2;
    elseif theta > setState + pi/6 || theta < setState - pi/5
        r = -1;
    else
        r = 1;
    end

    if theta <= setState + 0.1 &&  theta >= setState -0.1
        r *= 3;
    end
     
end
