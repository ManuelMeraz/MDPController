

function sPrime = mapToDiscreteValue(S, sPrime)
    % Map the real value given to us by the pendulum dynamics function
    % to a discrete state

    theta = sPrime(1,1);
    thetaDot = sPrime(2,1);

    if theta <= S(1,1)
        theta = S(1,1);
    elseif theta >= S(1, length(S))
        theta = S(1,length(S));
    else

        for i = 1:length(S) - 1
            if theta >= S(1,i) && theta <= S(1,i + 1)
                left = theta - S(1,i);
                right = S(1,i + 1) - theta;

                if(left < right) 
                    theta = S(1,i);
                else
                    theta = S(1,i+1);
                end
                break;
            end
        end
    end

    if thetaDot <= S(2,1)
        thetaDot = S(2,1);
    elseif thetaDot >= S(2, length(S))
        thetaDot = S(2,length(S));
    else

        for i = 1:length(S) - 1
            if thetaDot >= S(2,i) && thetaDot <= S(2,i + 1)
                left = thetaDot - S(2,i);
                right = S(2,i + 1) - thetaDot;

                if left < right
                    thetaDot = S(2,i);
                else
                    thetaDot = S(2,i+1);
                end
                break;
            end
        end
    end

    sPrime = [theta;thetaDot];

end
