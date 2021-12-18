function theta1=recursive(X,y)
    theta1 = (X'*X)\X'*y;
end 