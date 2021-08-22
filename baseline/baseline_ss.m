%Calculates the baseline model steady state

%Setting the parameters, starting values and moments to hit
run params_set;

%Loading parameters and creating structure for easy transfer
load ../data/params.mat params starting moments switches;

%Creating variables from the structures
params_names = fieldnames(params);
nn = length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end

starting_names = fieldnames(starting);
mm = length(starting_names);
for ii=1:mm
    eval([starting_names{ii} '=starting.' starting_names{ii} ';']);
end

switches_names = fieldnames(switches);
ll = length(switches_names);
for ii=1:ll
    eval([switches_names{ii} '=switches.' switches_names{ii} ';']);
end

%Calibrating the parameters to hit the moments
switch switch_print
    case 'test'
        options = optimset('Display','iter');
    otherwise
        options = optimset('Display','off');
end
[XX,diff,exitf] = fsolve(@f_mom_baseline,[omega0 gam0],options,params,starting,moments,switches);

omega = XX(1);
gam = XX(2);

switch switch_print
    case 'test'
        fprintf('omega: %1.6f\n',omega);
        fprintf('gam: %1.6f\n',gam);
end

%Creating structures for parameters and variables used by dynare
params_ss = params;
params_ss.omega = omega;
params_ss.gam = gam;

%Getting the variables
[vars_ss,varexo_ss] = f_simul_baseline(params_ss,starting,switches);

%Saving the parameters and the variables
save ../data/baseline_ss.mat params_ss vars_ss varexo_ss;
