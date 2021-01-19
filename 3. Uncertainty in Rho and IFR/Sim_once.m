%function with input u and main state parameters, runs once and gives
%resulting states x as output
function [x] = Sim_once(dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_set,u)

R = 1; %Cost associated with government strategy (used as basis)


T_days = 365; %Number of days
r = 0.00001;
%Initial conditions
x(1,1) = 1 - r; %S
x(2,1) = r; %I
x(3,1) = 0; %D
x(4,1) = 0; %A
x(5,1) = 0; %R
x(6,1) = 0; %E

%Data (Italy)
mu_h = 5*mu; %infection decease rate when hospital capacity is exceeded
T = T_days/dt; 

v(1:T,1) = v_set(1,1); %Constant value of v

u = u.';

for k=2:T
x(:,k) = epidem(dt, x(:,k-1), beta, u(k-1,1),v(k-1,1), gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, mu_h, H_th);
end



