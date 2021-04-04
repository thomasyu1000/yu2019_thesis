function diff = f_mom_capreq(XX,params,starting,moments,switches)

%Calculates difference from a vector of predetermined moments, for capital requirement model
%Input: XX: vector of starting values
%       params: structure of parameters
%Output: diff: difference from actual values

%Obtaining the starting values of parameters
Psi = XX(1);

%Creating new structure for submitted parameters for f_KL_capreq
params_f = params;

%Adding the values to the parameters
params_f.Psi = Psi;

[vars_ss,var_exo_ss] = f_simul_capreq(params_f,starting,switches);

%Getting the moments
Vbar_ss_mom = vars_ss.V;

%Obtaining moments
moments_names = fieldnames(moments);
kk = length(moments_names);
for ii=1:kk
    eval([moments_names{ii} '=moments.' moments_names{ii} ';']);
end

%Setting the differences
diff(1) = Vbar_ss - Vbar_ss_mom;
