%Function that provides the optimized strategy with a limited number of
%policies and policy changes
function [x_so, u_so, C_min, u_sv, t_sv]   =  discrete_cost_par(Discrete_card, n_2, I_val, val, q) 

    %Initialisation-------------------------------------------------------
    [u_opt, t_sw] = u_init_fun(I_val, val, q, Discrete_card, n_2); %Initialization of ordered set of policies,
    %u_opt and t_sw define the initial strategy with u_opt containing the
    %set of policies that change at times contained in t_sw, the set of
    %unique values within u_opt is less than or equal to Discrete_card and
    %the cardinality of t_sw less than or equal to n_2.

    conv = 0;%Convergence variable, while 0 the algorithm keeps running
    C_min = 1000; %Auxiliary parameter storing the cost at each iteration, initiated at a large value.
    C_min_c = C_min; %Auxiliary cost to check if there has been improvement at the end of every set of iterations
    
    %temporary variables to facilitate the algorithm
    u_sv = u_opt;
    t_sv = t_sw;
    while conv == 0
        for i1 = 1:2*Discrete_card
        %function to update the set of policies 
        u_opt = u_opt_fun(q, i1, u_sv);
        %function to get set of states x, u and Cost - optimizing the switching times of u - Algorithm 2
        [x_s, u_s, C_diff, t_sw] = discrete_u_x_policy(I_val, val,q, u_opt, t_sv);   
            %Check if cost has decreased, if yes then the new cost is saved
            %and the best strategies so far updated, otherwise, the last
            %change is reverted
            if C_diff < C_min
                C_min = C_diff;
                u_sv = u_opt;
                t_sv = t_sw;
                x_so = x_s;
                u_so = u_s;
            else
                u_opt = u_sv;
                t_sw = t_sv;
            end
        end
        %Check congergence - if not update the minimum cost value obtained
        if C_min_c == C_min
            conv = 1;
        else
            C_min_c = C_min;
        end
    end
    
    C_min = round(C_min,4); %rounded to 4 decimals for improved presentation

    