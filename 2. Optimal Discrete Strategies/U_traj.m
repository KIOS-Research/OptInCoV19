%reconstruct the trajectory of u based on the switching times t_st and
%policies u_opt_test
function u = U_traj(t_st, u_opt_test) 

K = length(t_st);

%loop that obtains a continuous strategy u from the switching times and set
%of policies
for i=K:-1:1
    u(1:t_st(i,1),1) = u_opt_test(i,1);
end