function qout = proj(q)
    Atil = ...
    [-eye(6); ...
        ones(1,6); ...
        1 0 1 0 1 0; ... 
        0 1 0 1 0 1];
    
    ptil = repmat([0.1;0.2],3,1);
    
    rh = zeros(6,1);
    for i = 1 : 3
        for t = 1 : 2
            rh((i-1)*2+t) = i * t;
        end
    end
    rl = rh / 9;
    
    A = [Atil'; -Atil';-eye(9)];
    B = [rh-ptil; ptil-rl;zeros(9,1)];
    Aeq = [zeros(1,7) ones(1,2)];
    Beq = 0.05;
    
    H = eye(9);
    f = -q;
    opts = optimoptions(@quadprog,'OptimalityTolerance',1e-10);
    qout = quadprog(H,f,A,B,Aeq,Beq,[],[],[],opts);
end