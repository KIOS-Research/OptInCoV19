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


%Script to obtain the optimal control strategies for
%different values of Rho
clear all;
clc;


N = 8; %number of considered steps in Rho


     
%Matrix of selections associated with the considered set of strategies
%First row corresponds to the selected cost emphasis on the acutely
%symptomatic population,  second row on the testing rate and third row on
%the cost associated with deceased population
Sel = [1     1     2     3     3     1     1     1;
       1     2     3     1     2     1     2     3;
       9     3     6     4     6     28    26    22];
    


v_val = [0;0.05;0.1]; %Testing rate values - values of v
Q_val = [0;50000;100000]; %Costs associated with acutely symptomatic population

%Costs associated with diseased population     
C_dth = [0; 200; 400; 600; 800; 1000; 1200; 1400;
         1600; 1800; 2000; 2500; 3000; 3500; 4000;
         4500; 5000; 6000; 7000; 8000; 9000; 10000;
         12000; 14000; 16000; 18000; 20000; 25000];

%Data (Italy)
gamma_i = 1/14; % Recovery rate from infected undetected
gamma_d = 1/14; % Recovery rate from infected detected
gamma_a = 1/12.39; %Recovery rate from hospitalized
H_in = 0.06925; %percentage of hospitalized
a_d = 0.0066/H_in; %so the infection mortality rate is 0.66%
mu = a_d/(1-a_d)*gamma_a; %Transition rate from acutely symptomatic to deceased

H_th =  333*10^-5; %Healthcare capacity associated with the case of Italy
ksi_i = H_in/(1-H_in)*gamma_i; %Transition rate from infected undetected to acutely symptomatic
ksi_d = H_in/(1-H_in)*gamma_d; %Transition rate from infected detected to acutely symptomatic
dt = 1; %Time increments

for q = 1:length(Sel(1,:)) %Loop associated with the selected strategies
            
            for i=1:N
                Rho(i,1) = 3.17+ 0.21*(i-1)/(N-1); %Range of value for R0 between 3.17 and 3.38
                beta(i,1) = Rho(i,1)*(gamma_i + ksi_i); %Definition of R0 in SIDARE model
            end

            m = Sel(1,q); %associated with the cost for acutely symptomatic population
            i = Sel(2,q); %associated with the adopted testing rate

            Q = diag([0;0;0;Q_val(m,1);0;0]); %Cost associated with states

            v_set = v_val(i,1); %Test rate associated with considered strategy


            parfor i=1 : N %Loop associated with the steps in Rho
                [x{i}, u(i,:),C(:,i), C1(:,i), C2(:,i), C3(:,i)] = Sim_simple(dt,beta(i,1),gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu, H_th,  C_dth(Sel(3,q),1), Q, v_set);
                %Function with input the model parameters and cost weights
                %and output the optimal strategy x and the resulting state
                %x and costs
            end
            
        %Workspace is saved in a local folder
        FileName   = ['Q_beta_' num2str(q) '.mat'];
        save(FileName)

end










