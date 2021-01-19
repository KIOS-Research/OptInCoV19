%function that updates u_opt by changing the value of a single policy 
function u_opt = u_opt_fun(q, i1, u_opt)

    N = 100; %step size is 1/N. There are N+1 possible policies between 0 and 1, i.e. 0, 0.01, ...
    
    File = 'Input_Data.mat';
    
    %load continuous strategy
    load(File,'u_all')
    u = u_all(q,:);
    
    u_opt_max = ceil(N*max(u))/N; %Map maximum value in u in the set of discrete maps
    
    u_set = unique(u_opt); %set of unique values within u_opt
    
    r1 = ceil(i1/2); %choose which value to change
    
    %This steps resolves issues in case the proposed strategy enables less
    %strategies than allowed
    if r1 > length(u_set)
        r1 = mod(r1,length(u_set));
        if r1 == 0
            r1 = length(u_set);
        end
    end
    
    %positions in u_opt to be updated
    r = find(u_opt == u_set(r1,1));
        
    r2 = mod(i1,2); %choose whether to increase or decrease
    
   %perform change in selected value, respecting the bounds in the policy
    if r2 == 1
        u_set(r1,1) = max(min(u_set(r1,1) + 1/N,u_opt_max),0); %increase if r2 = 1
    else
        u_set(r1,1) = max(min(u_set(r1,1) - 1/N,u_opt_max),0); %decrease if r2 = 0
    end
    
    %Update u_opt
    u_opt(r,1) = u_set(r1,1);
    
    