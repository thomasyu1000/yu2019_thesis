function diff = f_mom_baseline(XX,params,starting,moments,switches)

%Calculates difference from a vector of predetermined moments, for baseline model
%Input: XX: vector of starting values
%       params: structure of parameters
%Output: diff: difference from the predetermined vector of moments

%Obtaining the starting values
omega = XX(1);
gam = XX(2);

%Creating new structure for submitted parameters for f_KL_baseline
params_f = params;

%Adding the values to the parameters
params_f.omega = omega;
params_f.gam = gam;

[vars_ss,var_exo_ss] = f_simul_baseline(params_f,starting,switches);

%Getting the moments
V = vars_ss.V;
C_over_Y = vars_ss.C - vars_ss.Y;

%Obtaining moments
moments_names = fieldnames(moments);
kk = length(moments_names);
for ii=1:kk
    eval([moments_names{ii} '=moments.' moments_names{ii} ';']);
end

%Setting the differences
diff(1) = V - log(V_mom);
diff(2) = C_over_Y - log(C_over_Y_mom);
