%function to obtain optimal switching times

function [x_s,u_s, C_diff, t_sw_o] = discrete_u_x_policy(I_val, val,q, u_opt_in, t_sw_in)

    %Data extraction
    File       = 'Input_Data.mat';
    
    load(File,'u_all')
    load(File,'C_dth_all')
    load(File,'x_all')
    
    u = u_all(q,:).'; %continuous strategy
    C_dth = C_dth_all(q,1); %associated cost of deceased
    x = x_all{q,1}; %associated state trajectories
    

    %Matrix of selections associated with the considered strategy
    %First row corresponds to the selected cost emphasis on the acutely
    %symptomatic population and second on the testing rate
    Sel = [1     1     2     3     3     1     1     1;
           1     2     3     1     2     1     2     3];
    
    m = Sel(1,q); %associated with the cost for acutely symptomatic population
    i = Sel(2,q); %associated with the adopted testing rate
    
    
    v_0 = val(i,1); %Testing rate
    Q = diag([0;0;0;I_val(m,1);0;0]); %Cost associated with states
    R = 1; %Cost associated with government strategy (used as basis)

    
    %Parameters used in simulation-----------------------------------------

    T_days = 365; %Number of days
    dt = 1; %time increments

    %Initial conditions
    r = 0.00001;
    x_d(1,1) = 1 - r; %S
    x_d(2,1) = r; %I
    x_d(3,1) = 0; %D
    x_d(4,1) = 0; %A
    x_d(5,1) = 0; %R
    x_d(6,1) = 0; %E

    run Parameters

    beta = Rho*(gamma_i + ksi_i); %Definition of R0 in SIDARE, proven in paper
    
    mu = a_d/(1-a_d)*gamma_a; %Transition rate from acutely symptomatic to deceased
    mu_h = 5*mu; %infection decease rate when hospital capacity is exceeded
    T = T_days/dt; 

    
    
    %Initialization - x_d states resulting from a piecewise constant
    %strategy -------------------------------------------------------------
    x_d(:,1) = x(:,1);
    v(1:T,1) = v_0; %Value of v

    %Cost associated with continuous strategy - serves as lower
    %bound----------------------------------------------------------------
    C_min = 0.5*dt*(R(1,1)*u.'*u + Q(4,4)*(x(4,:)*x(4,:).')) + x(length(x(:,1)),T)*C_dth;
     
     %Auxiliary variables to facilitate the algorithm
     u_opt_test = u_opt_in; 

     t_st = t_sw_in*dt;
     t_st = round(t_st, 3);
     K = length(t_st);
     
    %Obtain the cost of the considered discrete strategy 
        C_test = Cost_find(t_st, u_opt_test, dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_0, Q,R,C_dth);
%      Cost_main(t_st, u_opt_test,v, Q, R, C_dth);   

    %Algorithm to optimize switching times
     C_test_s = C_test; %auxiliary variable 
     t_st2 = t_st; %auxiliary vector of switch time instants
     conv = 1; %Convergence variable, the algorithm keeps running while conv=1;
     while conv == 1
         conv = 0;
         for i=1:K-1
             s = 1; %Second convergence variable, the algorithm increases the time of a particular switch while the cost decreases
             while s == 1
                 t_st2(i,1) = min(t_st2(i,1) + dt, t_st2(i+1,1)); %Change in the switch time
                 C_test_n = Cost_find(t_st2, u_opt_test, dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_0, Q,R,C_dth);
%                  Cost_main(t_st2, u_opt_test,v, Q, R, C_dth);  %Cost calculation for the new strategy
                 %Test, if the cost has improved then save current cost and
                 %allow further time increments, otherwise revert last
                 %change.
                 if C_test_n < C_test_s
                     C_test_s = C_test_n; %Update cost
                     conv = 1; %any improvement in cost enables a new set of trials
                     t_st = t_st2; %save new set of times
                 else
                     t_st2 = t_st; %revert last change
                     s = 0; %no further increases on particular switch time
                 end
             end
             s = 1; %Second convergence variable, the algorithm decreases the time of a particular switch while the cost decreases
             while s == 1
                 if i> 1
                 t_st2(i,1) = max(t_st2(i,1) - dt, t_st2(i-1,1)); %Change in the switch time
                 else
                     t_st2(i,1) = max(t_st2(i,1) - dt, 1); %Change in the switch time
                 end
                 C_test_n = Cost_find(t_st2, u_opt_test, dt, beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th, v_0, Q,R,C_dth);
%                  Cost_main(t_st2, u_opt_test,v, Q, R, C_dth);  %Cost calculation for the new strategy
                  %Test, if the cost has improved then save current cost and
                 %allow further time decrements, otherwise revert last
                 %change.
                 if C_test_n < C_test_s
                     C_test_s = C_test_n;%Update cost
                     conv = 1; %any improvement in cost enables a new set of trials
                     t_st = t_st2; %save new set of times
                 else
                     t_st2 = t_st; %revert last change
                     s = 0;  %no further decreases on particular switch time
                 end
              end
         end
     end

     %Outputs--------------------------------------------------------------

     %Reconstruct a strategy input vector u_s based on the obtained
     %switching times and policy values
     for i=1:T
        for j=length(t_st):-1:1
            if i <= t_st(j,1)
              u_s(i,1) = u_opt_test(j,1);
            end
        end
     end
     
     t_sw_o = t_st;


    %Implement strategy u_s to obtain the resulting state trajectory x_s
        x_s(:,1) = x_d(:,1); %Initialisation
    for k=2:T
        x_s(:,k) = epidem(dt, x_s(:,k-1), beta(1,1), u_s(k-1,1),v(k-1,1),  gamma_i, gamma_d, gamma_a, ksi_i, ksi_d,  mu, mu_h, H_th);
    end
    
    %Percentage cost difference between the continuous and the discrete
    %code
    C_diff = C_test_s/C_min-1;
