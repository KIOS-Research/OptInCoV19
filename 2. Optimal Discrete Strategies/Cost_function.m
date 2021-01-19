%Cost calculation based on state x, input u and the cost coefficients
function C = Cost_function(dt,x,u,Q,R,C_dth)

T = length(u);
%Cost calculation
C = 0.5*dt*(R(1,1)*u.'*u + Q(4,4)*(x(4,:)*x(4,:).')) + x(length(x(:,1)),T)*C_dth;