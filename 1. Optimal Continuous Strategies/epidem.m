%function describing the dynamics of the controlled SIDARE model

function [y,dy] = epidem(dt, x, beta,u,v, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu,mu_h, H_th)

    %Impact of the healthcare capacity limit on the mortality rate
    if x(4,1) < H_th %Case where the hospitalization needs are below the capacity
        d1 = mu*x(4,1);
        g1 = gamma_a*x(4,1);
    else %Hospitalization needs are above the capacity
        d1 = mu*H_th + (x(4,1) - H_th)*mu_h;
        g1 = gamma_a*x(4,1);
    end
    
    %Controlled SIDARE model
    dy(1,1) = -beta*(1 - u)*x(1,1)*x(2,1); %Susceptible State
    dy(2,1) = beta*(1 - u)*x(1,1)*x(2,1) - gamma_i*x(2,1) - ksi_i*x(2,1) - v*x(2,1); %Infected undetected State
    dy(3,1) = v*x(2,1) - gamma_d*x(3,1) - ksi_d*x(3,1); %Detected infected State
    dy(4,1) = ksi_i*x(2,1) +  ksi_d*x(3,1) - g1 - d1; %Acutely symptomatic State
    dy(5,1) = gamma_i*x(2,1) +  gamma_d*x(3,1) + g1; %Recovered State
    dy(6,1) = d1; %Extinct (Deceased) State
    y = x + dt*dy; %State update



