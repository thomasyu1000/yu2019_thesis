function [vars,varexo]=f_simul_baseline(params,starting,switches)

%Calculates steady state values using the parameters, for baseline or debt tax model
%Input: params: structure of parameters
%Output: vars: structure of steady state values

%Creating variables from the params structure
params_names = fieldnames(params);
nn=length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end

%Obtaining starting values
K0 = starting.K0;
L0 = starting.L0;

%Calculating the equilibrium K and N values given the parameters
switch switches.switch_print
    case 'test'
        options = optimset('Display','iter');
    otherwise
        options = optimset('Display','off');
end
[XX_ss,fval,exitf] = fsolve(@f_KL_baseline,[K0 L0],options,params);

K = XX_ss(1);
L = XX_ss(2);

switch switches.switch_print
    case 'test'
        fprintf('\nK_ss: %2.2f\n',K);
        fprintf('L_ss: %2.2f\n',L);
        fprintf('diff: %1.8f, %1.8f\n',[fval(1) fval(2)]);
        fprintf('exitf: %1.0f\n',exitf);        
end

%Calculating steady state values

%Endogenous variables
Q = 0;
Y = log(exp(K)^alfa * exp(L)^(1-alfa));
I = log(delta*exp(K));
R = log((1+tau)/betta);
Rk = log(alfa*exp(Y)/exp(K) + 1-delta);
N = log((theta*(exp(Rk)-exp(R))*exp(K) + omega*exp(K)) / (1-theta*exp(R)));
B = log(exp(K) - exp(N));
C = log(exp(Y) - exp(I) - gam*exp(B));
Uc = log((1-betta*hh)/((1-hh)*exp(C)));
Lambda = 0;
W = log((1-alfa)*exp(Y)/exp(L));
Omega = (log((1-hh)*exp(C)) - exp(L)^(1+phi)/(1+phi)) / (1-betta);
prem = Rk - R;
V = N - (Q+K);
A = 0;
Z = 0;

%Shocks
e_a = 0;
e_z = 0;

%Creating a structure with endogenous variables
vars_cell = {'Y';'K';'L';'I';'C';'Uc';'Lambda';'Q';'R';'Rk';'N';'W';'prem';'B';'V';'Omega';'A';'Z'};
nn_vars = length(vars_cell);
for ii=1:nn_vars
    eval(['vars.' vars_cell{ii} '=' vars_cell{ii} ';']);
end

%Creating a structure with exogenous variables
varexo_cell = {'e_a'; 'e_z'};
nn_varexo = length(varexo_cell);
for ii=1:nn_varexo
    eval(['varexo.' varexo_cell{ii} '=' varexo_cell{ii} ';']);
end
