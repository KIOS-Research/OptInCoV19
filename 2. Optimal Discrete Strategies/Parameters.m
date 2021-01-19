%Main parameters used

    %Data - associated with the case of Italy
    Rho = 3.27; %based on 'Monitoring transmissibility and mortality'
    gamma_i = 1/14; % Recovery rate from infected undetected
    gamma_d = 1/14; % Recovery rate from infected detected
    gamma_a = 1/12.39; %Recovery rate from hospitalized
    H_in = 0.06925; %percentage of hospitalized
    a_d = 0.0066/H_in; %so the infection mortality rate is 0.66%
    ksi_i = H_in/(1-H_in)*gamma_i; %Estimating the severity of coronavirus
    ksi_d = H_in/(1-H_in)*gamma_d; %Estimating the severity of coronavirus
    
    dt = 1; %time increments
    
    H_th = 333*10^-5; %Italy case (333 beds per 100,000 people)