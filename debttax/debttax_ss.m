%Calculates the debt tax model steady state
%Before running this: run ../baseline/baseline_ss, set tau

%Get calibrated parameters from baseline model
load ../data/baseline_ss.mat params_ss;

%Set debt tax
params_ss.tau = tau;

%Get starting and switches
load ../data/params.mat starting switches;

%Getting the variables
cd ../baseline
[vars_ss,varexo_ss] = f_simul_baseline(params_ss,starting,switches);

%Saving the parameters and the variables
save ../data/debttax_ss.mat params_ss vars_ss varexo_ss;

cd ..