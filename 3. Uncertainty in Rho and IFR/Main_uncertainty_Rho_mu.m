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


%Performance of proposed inputs on changes in beta and mu. In this
%algorithm we simulate the response of the population with given
%parameters for R0 and the infection fatality rate in specific ranges
%when a strategy that is optimally selected with R = 3.26 and
%infection fatality rate of 0.66% is applied.

clc;
clear all

N = 50; %Number of considered step increments of values in the ranges given for R0 and the infection fatality rate

v_val = [0;0.05;0.1]; %Testing rate values - values of v

   
for q=1:8 %loop associated with selected continuous strategy
        
        %Matrix of selections associated with the testing rate of the considered strategy
        Sel = [1     2     3     1     2     1     2     3];

        i = Sel(1,q); %associated with the adopted testing rate
        v_set = v_val(i,1);%Testing rate for considered strategy
        
        %Data extraction
        File       = 'Input_Data.mat';
        load(File, 'u_all'); 
        
        u_sel = u_all(q,:);
        T = length(u_sel);
        
        

        dt = 1;
        
        %Data (Italy)
        Rho = 3.27; %based on 'Monitoring transmissibility and mortality'
        gamma_i = 1/14; % Recovery rate from infected undetected
        gamma_d = 1/14; % Recovery rate from infected detected
        gamma_a = 1/12.39; %Recovery rate from hospitalized
        H_in = 0.06925; %percentage of hospitalized
        
        H_th = 333*10^-5; %Italy case (333 beds per 100,000 people)
        ksi_i = H_in/(1-H_in)*gamma_i; %Estimating the severity of coronavirus
        ksi_d = H_in/(1-H_in)*gamma_d; %Estimating the severity of coronavirus
        
    for j=1:N %loop associated with different values of infection mortality rates
        v_ad(j,1) = 0.0039 + (0.0133 - 0.0039)*(j-1)/(N-1); %range of values for mortality rate between 0.39% and 1.33%
        a_d(j,1) = v_ad(j,1)/H_in; %so that infection mortality rate is v_ad*100%
        mu(j,1) = a_d(j,1)/(1-a_d(j,1))*gamma_a; %resulting value for mu
        for i=1:N %loop associated with different values of basic reproduction number R0
            Rho(i,1) = 3.17 + 0.21*(i-1)/(N-1); %Range of value for R0 between 3.17 and 3.38
            beta(i,1) = Rho(i,1)*(gamma_i + ksi_i); %Definition of R0 in SIDARE, proven in our paper
            [x{N*(q-1) + j,i}] = Sim_once(dt,beta(i,1),gamma_i, gamma_d, gamma_a, ksi_i, ksi_d, mu(j,1), H_th, v_set, u_sel);
            %Function that simulates the response with the given parameters
            %and the strategy that is optimally selected with R = 3.26 and
            %infection fatality rate of 0.66%.
            Deceased{q,1}(j,i) = x{N*(q-1) + j,i}(6,T)*100; %Deceased population associated with current iteration in percentage (%)
        end
    end       
end