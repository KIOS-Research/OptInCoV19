%function that selects the set of policies for initialization, output u_opt_test are the distinct policies and t_s the times of switch    
function [u_opt_test, t_s] = u_init_fun(I_val, val, q, Discrete_card, n_2)

    N = 100; %step size is 1/N. There are N+1 possible policies between 0 and 1, i.e. 0, 0.01, ...
    
    %Data extraction
    File       = 'Input_Data.mat';
    
    %load continuous strategy
    load(File,'u_all')
    u = u_all(q,:).'; %continuous strategy selection
    
    u_opt_max = ceil(N*max(u))/N; %Map maximum value in u in the set of discrete maps
    u_opt = linspace(0, u_opt_max, Discrete_card).'; %Create a set of Discrete_card values of equal differences between 0 and u_opt_max
    u_opt = ceil(N*u_opt)/N; %Map new set in the set of discrete maps
    
    
    %check compatibility
    
    load(File,'C_dth_all')
    C_dth = C_dth_all(q,1); %associated cost of deceased
    

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

    
    T_days = 365; %Number of days
    dt = 1; %time increments
    T = T_days/dt; 
    
    %Initialization - x_d states resulting from a piecewise constant
    %strategy -------------------------------------------------------------

    
    %Create strategy u_disc which takes the optimal continuous strategy u and maps
    %it to the values of the vector u_opt
    for i=2:T
        u_disc(i,1) = u_opt(length(u_opt),1);
        for j = length(u_opt):-1:2
            if u(i,1) < 0.5*(u_opt(j-1,1) + u_opt(j,1))
                u_disc(i,1) = u_opt(j-1,1);
            end
        end
    end
    u_disc(1,1) = u_disc(2,1);


    %Obtain the set of policy values u_opt_test and switching times
    %t_s-------------------------------------------------------------------
     k = 1;  
     for i = 2:T
         if u_disc(i,1) ~= u_disc(i-1,1)
             t_s(k,1) = i-1; %switching times
             u_opt_test(k,1) = u_disc(i-1,1); %Difference of u_opt_test with u_opt is that u_opt_test may have dublicate values of one policy, i.e. it is associated with the order of policies
             k = k+1;
         end
     end
     u_opt_test(length(t_s) +1,1) = u_disc(T,1); %last policy, which has not been attributed yet
     T_length = length(t_s); %number of switches in policy
     t_s(length(t_s) +1,1) = T; %Added as last time interval to facilitate the algorithm, but does not count as a switching time  

     
     
     %Consider the case the number of switches exceeds the allowed
     %number
     if T_length > n_2
         [u_opt_test, t_s] = limit_switches(n_2, u_opt_test, t_s, v_0, Q, R, C_dth);
         %Resolve issue to create a compatible strategy
     end
     
     
     
     