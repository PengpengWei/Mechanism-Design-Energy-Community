% x = [x11 x12 x21 x22 x31 x32];
%% Parameters
p0 = 0.05;
p = 0.1 *[1 2];
N = 3; T = 2;

J = @(x) (p(1) * sum(x([1 3 5])) + p(2) * sum(x([2 4 6])) + p0 * max([sum(x([1 3 5])),sum(x([2 4 6]))]));
U = @(x) log(x(1)+2) + 2 * log(x(2)+2) + 2 * log(x(3)+2) + 4 * log(x(4)+2) + 3 * log(x(5) + 2) + 6 * log(x(6)+2);
func = @(x) -(U(x) - J(x)); % minimize the opposite.
A = [-eye(6); 1 1 1 1 1 1];
b = [ones(6,1); 2];

sol = fmincon(func,zeros(6,1),A,b);

%% PGD
l = (249+sqrt(106201)) / 520;
qopt = [l+0.1-1; 0; 0; 0; 0; 0; l; 0; 0.05];
yopt = [-1; 2/(l+0.25)-2; 2/(l+0.1)-2; 4/(l+0.25)-2; 3/(l+0.1)-2; 6/(l+0.25)-2];

Atil = ...
[-eye(6); ...
    ones(1,6); ...
    1 0 1 0 1 0; ... 
    0 1 0 1 0 1];
ptil = repmat([p(1);p(2)],3,1);

A = [-eye(6); ones(1,6)];
b = [ones(6,1); 2];

K=100; alpha=0.1; 
q0 = zeros(9,1);

q = proj(q0);
y = price_taking(q);
dist_q = zeros(K,1);
dist_y = zeros(K,1);
for k = 1 : K
    q([1:7]) = q([1:7]) - alpha * (b - A * y);
    q([8:9]) = q([8:9]) + alpha * [1 0 1 0 1 0; 0 1 0 1 0 1] * y;
    q = proj(q);
    y = price_taking(q);
    dist_q(k) = norm(q-qopt);
    dist_y(k) = norm(y-yopt);
end

%% Figure Plot
figure(1)
subplot(121)
semilogy(dist_q/norm(qopt))
title('The Convergence of Prices $(\mathbf{q},\mathbf{s})$','Interpreter','latex','fontsize',17) 
xlabel('# of Iterations','fontsize',15); ylabel('$||(\mathbf{q},\mathbf{s})-(\mathbf{\lambda}^*,\mathbf{\mu}^*)||$','Interpreter','latex','fontsize',15)
grid on

subplot(122)
semilogy(dist_y/norm(yopt))
title('The Convergence of Demands $\mathbf{y}$','Interpreter','latex','fontsize',17) 
xlabel('# of Iterations','fontsize',15); ylabel('$||\mathbf{y}-\mathbf{x}^*||$','Interpreter','latex','fontsize',15)
grid on
