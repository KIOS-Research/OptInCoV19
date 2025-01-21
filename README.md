<a href="http://www.kios.ucy.ac.cy"><img src="https://www.kios.ucy.ac.cy/wp-content/uploads/2021/07/Logotype-KIOS.svg" width="200" height="100"/><a>

[![DOI](https://img.shields.io/badge/Paper-Nature%20Scientific%20Reports-blue?style=flat&logo=nature&logoColor=white)](https://www.nature.com/articles/s41598-022-09857-8)  
[![Dataset](https://img.shields.io/badge/Dataset-Zenodo-black?style=flat&logo=zenodo&logoColor=white)](https://zenodo.org/records/4433506)  
[![Code](https://img.shields.io/badge/Code-CodeOcean-orange?style=flat&logo=codeforces&logoColor=white)](https://codeocean.com/capsule/9137604)

# OptInCoV19

Repository for 'Optimal intervention strategies to mitigate the COVID-19 pandemic effects'

Welcome to the repository related to the paper 'Optimal intervention strategies to mitigate the COVID-19 pandemic effects'.

SYSTEM REQUIREMENTS

All the scripts listed were developed using MATLAB R2020a on Windows 10 (64-bit) OS. 
The hardware used for simulations is an Intel Core i7-7700HQ CPU with 8Gb RAM DDR4. 
On this system, each simulation to obtain an optimal continuous strategy with 100,000 iterations required approximately 10 minutes.

REPOSITORY ORGANIZATION

The repository is organized as follows:

(1) The folder 'Optimal Continuous Strategies' includes the code to obtain the optimal continuous strategy for a set of parameters. 
(2) The folder 'Optimal Discrete Strategies' includes the code to obtain optimized strategies with a small number of policies and policy changes. The code uses the datafile 'Input_Data' obtained from the code in (1).
(3) The folder 'Uncertainty in Rho and IFR' includes the code to obtain the results associated with the impact of parametric uncertainty. The code uses the datafile 'Input_Data' obtained from the code in (1).
(4) The folder 'Optimal Continuous Strategies - Uncertainty in Rho' includes the code to obtain optimal continuous strategies for a range of values for R_0.


To produce the main results of the paper, presented in Fig. 2-5 in the main text and Supplementary Fig. 3 - 26, the code in the following folders was used:
(i) For Fig. 2, the script in (1) was used.
(ii) For Fig.3, and Supplementary Fig. 3 - 10, we used the script in (1) and (2) to obtain the optimal continuous strategies and optimized discrete strategies respectively.
(iii) For Fig. 4, the script in (2) was used to obtain the cost differences.
(iv) For Fig. 5, Supplementary Fig. 11-18 (right) and Supplementary Fig. 19-26, the script in (3) was used.
(v) For Supplementary Fig. 11-18 (left), the script in (4) was used.


SIMULATION DESCRIPTION

The simulations are carried by a discrete time model where each iteration corresponds to a day. 
Below, we present a list of all the files contained and their role in the numerical simulations.

1. Optimal Continuous Strategies

(a) 'Main_Optimal_cnt_strategies_costs' contains the main code of the script. 
It includes the set of parameters of the model and a range of values for testing rate, healthcare capacity and cost weights for acutely symptomatic and deceased population. 
It parallelizes the operation for improved efficiency. 
(b) 'Sim_simple' is a function that takes a set of parameters and cost weights and gives an optimal continuous strategy and the corresponding state trajectories and costs. 
To achieve this it runs 100,000 iterations of a forward backward code which gradually takes the output trajectories closer to the optimal.
(c) 'epidem' is a function that simulates the controlled SIDARE model. In particular, it takes the states and input of the controlled SIDARE model at time t and gives the state at t+1.
(d) 'pontr' is a function that simulates the trajectories of the costate model following Pontryagin's equations associated with the controlled SIDARE model. 
Since final conditions are imposed on co-state variables, this algorithm runs backwards in time.

2. Optimal Discrete Strategies

(a) 'Main_Discrete_multi_policy_par' contains the main script of this file. 
Its inputs are the cost coefficients for acutely symptomatic population, the testing rates, the model parameters and the allowed number of distinct policies and policy changes.
In addition, it uses the continuous strategies associated with these selections, obtained from the script in (1). 
Its outputs for each case, are the optimized discrete strategies and the corresponding states, the (%) cost difference from the corresponding continuous strategy, and vectors 
of selected policy levels and switching times.
For improved efficiency, the operation is parallelized.
(b) 'discrete_cost_par' runs three other functions using the inputs from (a). 
It first obtains a feasible strategy (i.e. which satisfies the constraints on number of policies and changes) from 'u_init_fun'.
Then it obtains incremental changes in the distinct values and the optimized switching times and corresponding cost for the new set of policies, using the 'u_opt_fun' and 'discrete_u_x_policy' functions.
If there is an improvement, the strategy is updated, otherwise the last change is reverted.
It outputs, for the given set of input parameters, the optimized discrete strategies and the corresponding states, the (%) cost difference from the corresponding continuous strategy, and vectors 
of selected policy levels and switching times.
The function corresponds to Algorithm 1 in the paper.
(c) 'u_init_fun' creates a strategy that satisfies the constraints imposed on the allowed number of policies and changes. 
It creates a strategy which satisfies the constraint on the number of allowed policies using the continuous strategy u. 
If this policy violates the constraint on the number of switches, then the 'limit_switches' function resolves it.
(d) 'limit_switches' has as input the problem parameters and a strategy that violates the constraint on the allowed number of changes.
It provides a strategy that satisfies the latter constraint, using the same set of policies.
It does this by neglecting one switch at a time and evaluate the corresponding cost and then removing the switches with the lowest cost until the constraint is satisfied.
(e) 'Cost_find' obtains the cost associated with a particular input strategy.
Its inputs are the sequence of policies and the corresponding times.
(f) 'U_traj' reconstructs the intervention strategy trajectory u using the sequence of policies and the corresponding times.
(g) 'Sim_once' uses the system parameters and the intervention strategy trajectory to obtain the state trajectories.
(h) 'Cost_function' calculates the cost, using the intervention strategy, the states and the cost coefficients.
(i) 'u_opt_fun' sequentially changes the value of a single policy, either by increasing or decreasing it. 
The input is the current policy, i.e. the one which enables the lowest cost so far.
(j) 'discrete_u_x_policy' uses the current set of distinct policies and switching times and provides an optimized set of switching times.
This is done by making incremental changes to the set of switching times and saving a new set when there is a cost improvement.
The function corresponds to Algorithm 2 in the paper.
(k) 'epidem' is as in (1c).
(l) 'pontr' is as in (1d).
(m) 'Parameters' contains the values of the main parameters. It offers code compactness.


3. Uncertainty in Rho and IFR

(a) 'Main_uncertainty_Rho_mu' implements the optimal continuous strategy obtained with R0 = 3.27 and infection fatality rate (IFR) of 0.66% to the case where either 
R0 or IFR (or both) have been incorrectly estimated.
The output is the states trajectory.
(b) 'Sim_once' is as in (2g).
(c) 'epidem' is as in (1c).

4. Optimal Continuous Strategies - Uncertainty in Rho

(a) 'Main_Uncertainty_Rho' obtains the optimal continuous strategy for the considered set of parameters and different values of R0.
The outputs are the optimal continuous strategy and the corresponding state trajectories and costs.
(b) 'Sim_simple' as in (1b).
(c) 'epidem' is as in (1c).
(d) 'pontr' is as in (1d).
