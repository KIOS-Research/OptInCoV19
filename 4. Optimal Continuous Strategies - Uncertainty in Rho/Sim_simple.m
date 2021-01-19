%Function that takes as inputs a set of model paramters associated with the
%controlled SIDARE model and gives the optimal continuous strategy u,
%the resulting state trajectories x, and cost C. Costs C1, C2 and C3 are
%associated with the strategy, the acutely symptomatic population and the
%number of deaths respectively.-------------------------------------------- 
function [x, u, C, C1, C2, C3] = Sim_simple(dt, beta,  gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, C_dth, Q, v_set )



T_days = 365; %Number of days

R = 1; %Cost associated with government strategy (used as basis)


%Initial conditions
r = 0.00001;
x(1,1) = 1 - r; %S
x(2,1) = r; %I
x(3,1) = 0; %D
x(4,1) = 0; %A
x(5,1) = 0; %R
x(6,1) = 0; %E

%Data (Italy)
T = T_days/dt; 
l(1:length(x(:,1)),T) = 0; %Lambda boundary conditions
l(length(x(:,1)),T) = C_dth; %Cost attributed to number of deaths
mu_h = 5*mu; %infection decease rate when hospital capacity is exceeded
u_max = 0.8; %maximum value for u

u(1:T,1) = 0.4; %Initialisation of u
v(1:T,1) = v_set; %Constant value of testing rate, ν


%Initialization of states and costs
for k=2:T
x(:,k) = epidem(dt, x(:,k-1), beta(1,1), u(k-1,1),v(k-1,1), gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, mu_h, H_th);
end

for k=T-1:-1:1
[l(:,k), dl(:,k)] = pontr(dt, l(:,k+1), x(:,k+1), u(k+1,1), v(k+1,1), beta(1,1), gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, mu_h, H_th, Q);
end


%Cost function - aggregate and components----------------------------------
C(1,1) = 0.5*dt*(R(1,1)*u.'*u + Q(4,4)*(x(4,:)*x(4,:).')) + x(length(x(:,1)),T)*C_dth; %total cost
C1(1,1) = 0.5*dt*(R(1,1)*u.'*u); %cost associated with government strategy u
C2(1,1) = 0.5*dt*(Q(4,4)*(x(4,:)*x(4,:).')); %cost associated with the acutely symptomatic population
C3(1,1) = x(length(x(:,1)),T)*C_dth; %cost associated with number of deaths




N_iter = 100000; %number of iterations for the convergence of the algorithm

for j=1:N_iter

    %Calculation of the new value for u
    u0 = u;
    for k=1:T
        u1(k,1) = min(max(inv(R(1,1))*beta(1,1)*x(1,k)*x(2,k)*(l(2,k) - l(1,k)),0),u_max);
    end
    
    a = 0.9995; %coefficient used to update the current u 
    u = a*u0 + (1-a)*u1;%new strategy u
    
    %Update the SIDARE model trajectory based on current u
    for k=2:T
        %Controlled SIDARE epidemic model
        x(:,k) = epidem(dt, x(:,k-1), beta(1,1), u(k-1,1), v(k-1,1), gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, mu_h, H_th);
    end
    
    %Update the costate variables
    for k=T-1:-1:1
        %Pontryagin equations
        [l(:,k), dl(:,k)] = pontr(dt, l(:,k+1), x(:,k+1), u(k+1,1), v(k+1,1),  beta(1,1), gamma_i, gamma_d, gamma_a, ksi_i, ksi_d,mu,mu_h, H_th, Q);
    end



    %Cost function - aggregate and components associated with iteration j
    C(j,1) = 0.5*dt*(R(1,1)*u.'*u +  Q(4,4)*(x(4,:)*x(4,:).')) + x(length(x(:,1)),T)*C_dth; %total cost
    C1(j,1) = 0.5*dt*(R(1,1)*u.'*u);  %cost associated with government strategy u
    C2(j,1) = 0.5*dt*(Q(4,4)*(x(4,:)*x(4,:).'));  %cost associated with the acutely symptomatic population
    C3(j,1) = x(length(x(:,1)),T)*C_dth; %cost associated with number of deaths
end