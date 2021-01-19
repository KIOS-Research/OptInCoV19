%Function with aim to provide a set of policies and switching times that
%satisfies the constraints of our problem
function [u_opt_test_o, t_s_o] = limit_switches(n_2, u_opt_test, t_s, v, Q, R, C_dth)

T_length = length(t_s) - 1; %amount of switches in proposed strategy, minus 1 is due to the additional element in t_s at t=T.
q = T_length - n_2; %amount of switches that need to be removed to have a feasible strategy

%Obtain parameter values
run Parameters

mu = a_d/(1-a_d)*gamma_a; %Transition rate from acutely symptomatic to deceased
beta = Rho*(gamma_i + ksi_i); %Definition of R0 in SIDARE, proven in paper


%Loop to obtain the costs of policies following by removing one switch from
%the original strategy
for i=1:T_length
    u_opt_t = u_opt_test; %create temporary variable of policies
    t_s_t = t_s; %create temporary variable of switching times
    %Remove the ith switch and the policy that corresponds to it
    u_opt_t(i,:) = [];
    t_s_t(i,:) = [];
    %Obtain the cost of the considered discrete strategy
    Cost_s(i,1) = Cost_find(t_s_t, u_opt_t, dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v, Q,R,C_dth); %Obtained cost
    Cost_s(i,2) = i; %aids to find the set of switches with the lower increase
end

Cost_srt = sortrows(Cost_s,1); %matrix that sorts costs in ascending order
a = Cost_srt(1:q,2); %q iterations which resulted in lower costs

%Creating the outputs by first copying the inputs and then removing the set
%of switches that result in the lower cost increase
u_opt_test_o = u_opt_test;
t_s_o = t_s;
u_opt_test_o(a,:) = [];
t_s_o(a,:) = [];