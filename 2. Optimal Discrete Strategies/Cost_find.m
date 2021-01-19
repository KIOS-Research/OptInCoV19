%Function that obtains the cost associated with strategy with policy levels
%in u_opt_test and switching times at t_st
function C = Cost_find(t_st, u_opt_test, dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_0, Q,R,C_dth)

        u = U_traj(t_st, u_opt_test); %reconstruction of trajectory u, used to obtain the resulting states and costs
        x = Sim_once(dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_0,u); %obtain the state with input u
        C = Cost_function(dt,x,u,Q,R,C_dth); %Obtain the cost associated with u and x
        