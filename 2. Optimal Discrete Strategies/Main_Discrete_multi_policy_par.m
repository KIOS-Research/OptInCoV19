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


%Script to obtain optimized strategy u_save from the optimal continuous
%strategy. x_save and C_d are the corresponding state trajectories and
%costs. u_pol and t_sw are additional outputs presenting the set of
%policies and times of switch for each strategy

clc;
clear all


I_val = [0; 50000; 100000]; %Cost weights associated with acutely symptomatic population
v_val = [0; 0.05; 0.1]; %Testing rates - values of parameter v


D_n = 8; %8 considered continuous strategies


%Vector containing all allowed number of maximum distinct policies
Card_value = [2;3;4;5;6;7;8;9;10;12;14];
N = length(Card_value); %Total number of considered options for discete policy numbers


for q = 1:D_n %Loop associated with selected strategy
    parfor i= 1:N %Loop associated with selected value of distinct policies
        n_2 = 2*(Card_value(i,1) - 1); %Allowed number of changes in policy
        [x_save{q,i}, u_save{q,i}, C_d(i,q), u_pol{q,i}, t_sw{q,i}] = discrete_cost_par(Card_value(i,1),n_2, I_val, v_val, q);
    end
end



 
 

