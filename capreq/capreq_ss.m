%Calculates the capital requirement model steady state
%Before running this: run ../baseline/baseline_ss, set kappa_b, kappa_y, Vbar_ss

%Get switches
load ../data/params.mat starting switches moments;

%Get calibrated parameters from baseline model
load ../data/baseline_ss.mat params_ss;
params = params_ss;

%Set capital requirement parameters
params.kappa_b = kappa_b; %Debt feedback parameter
params.kappa_y = kappa_y; %Output feedback parameter

%Set moments to hit
moments.Vbar_ss = Vbar_ss; %Steady state log Vbar

%Set starting values
starting.Psi0 = Vbar_ss-kappa_b-kappa_y; %Constant parameter (log_Vss - kappa_b*log_Bss - kappa_y*log_Yss)

%Calibrating the parameters to hit the moments
switch switches.switch_print
    case 'test'
        options = optimset('Display','iter');
    otherwise
        options = optimset('Display','off');
end
[XX,diff,exitf] = fsolve(@f_mom_capreq,[starting.Psi0],options,params,starting,moments,switches);

Psi = XX(1);

switch switches.switch_print
    case 'test'
        fprintf('Psi: %1.6f\n',Psi);
end

%Creating structures for parameters and variables used by dynare
params_ss = params;
params_ss.Psi = Psi;

%Getting the variables
[vars_ss,varexo_ss] = f_simul_capreq(params_ss,starting,switches);

%Saving the parameters and the variables
save ../data/capreq_ss.mat params_ss vars_ss varexo_ss;
