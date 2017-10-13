function a = getActionFromPolicy(Policy, sPrime)
    % Searches through policy for optima action
    % theta and thetaDot must be in their discretized form
    thetaD = sPrime(1,1);
    thetaDotD = sPrime(2,1);

    % When looking up in policy for a discrete state
    % Consider a slight variance due to rounding error
    e = 0.00001; 

    for j = 1:length(Policy)
        if thetaD <= Policy(1,j)+e && thetaD >= Policy(1,j)-e ...
           && thetaDotD<= Policy(2,j)+e && thetaDotD >= Policy(2,j)-e 
           a = Policy(3, j);
           break;
       end
    end
end

