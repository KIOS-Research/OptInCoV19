%{
 Copyright (c) 2020 KIOS Research and Innovation Centre of Excellence
 (KIOS CoE), University of Cyprus (www.kios.org.cy)
 
 Licensed under the EUPL, Version 1.2;
 You may not use this work except in compliance with theLicence.
 
 You may obtain a copy of the Licence at: https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12
 
 Unless required by applicable law or agreed to in writing, software distributed
 under the Licence is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the Licence for the specific language governing permissions and limitations under the Licence.
 
 Author        : Andreas Kasis 
 Work address  : KIOS Research Center, University of Cyprus
 email         : kasis.andreas@ucy.ac.cy 
 Website       : http://www.kios.ucy.ac.cy
 
 Last revision : January 2021
%}



%Script to simulate a number of cases on the controlled SIDARE model. 
%The different cases considered are associated with the testing rate, 
%healthcare capacity and cost wieghts for acutely symptomatic and deceased
%population----------------------------------------------------------------
clear all;
clc;



v_val = [0;0.05;0.1]; %Testing rate values - values of v
Q_val = [0;50000;100000]; %Costs associated with acutely symptomatic population
     
%Costs associated with diseased population     
C_dth = [0; 200; 400; 600; 800; 1000; 1200; 1400;
         1600; 1800; 2000; 2500; 3000; 3500; 4000;
         4500; 5000; 6000; 7000; 8000; 9000; 10000;
         12000; 14000; 16000; 18000; 20000; 25000];
N = length(C_dth); %number of iterations
     
     
%Data (Italy)
Rho = 3.27; %based on 'Monitoring transmissibility and mortality'
gamma_i = 1/14; % Recovery rate from infected undetected
gamma_d = 1/14; % Recovery rate from infected detected
gamma_a = 1/12.39; %Recovery rate from hospitalized
H_in = 0.06925; %percentage of hospitalized - range between 5% and 12%
a_d = 0.0066/H_in; %so the infection mortality rate is 0.66%
mu = a_d/(1-a_d)*gamma_a; %Transition rate from acutely symptomatic to deceased
dt = 1; %time increments

for q = 1:3 %associated with three different cost weights for the acutely symptomatic population
    for f = 1:3 %Different testing rate policies
        for j=1:3 %Different healthcare capacity levels

            H_th =  [222; 333; 444]*10^-5; %Healthcare capacity associated with the case of Italy
            ksi_i = H_in/(1-H_in)*gamma_i; %Transition rate from infected undetected to acutely symptomatic
            ksi_d = H_in/(1-H_in)*gamma_d; %Transition rate from infected detected to acutely symptomatic
            beta = Rho*(gamma_i + ksi_i); %Definition of R0 in SIDARE, proven in our paper

            Q = diag([0;0;0;Q_val(q,1);0;0]); %Cost associated with states

            v_set = v_val(f,1); %Adopted testing rate


            %Different cases of cost weights associated with deceased
            %population---------------------------------------------------
            parfor i=1 + (j-1)*N:N + (j-1)*N
                [x{i}, u(i,:),C(:,i), C1(:,i), C2(:,i), C3(:,i)] = Sim_simple(dt,beta, gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th(j,1),  C_dth(i - (j-1)*N,1), Q, v_set);
            end
        end

        %Workspace is saved in a local folder
        FileName   = ['Q_' num2str(Q(4,4)) '_v_' num2str(v_set) '.mat'];
        save(FileName)

    end
end








