function diff=f_KL_baseline(XX,params)

%Calculates the steady state capital, for baseline or debt tax model
%Output: diff: difference between the lhs and rhs of the equilibrium condition (needs to be 0)
%Input: XX: vector of capital and labor (K,N)
%       params: structure of parameters

K = XX(1);
L = XX(2);

%Creating variables from the params structure
params_names = fieldnames(params);
nn=length(params_names);
for ii=1:nn
    eval([params_names{ii} '=params.' params_names{ii} ';']);
end

%Calculating steady state values
Y = log(exp(K)^alfa * exp(L)^(1-alfa));
I = log(delta*exp(K));
R = log((1+tau)/betta);
Rk = log(alfa*exp(Y)/exp(K) + 1-delta);
N = log((theta*(exp(Rk)-exp(R))*exp(K) + omega*exp(K)) / (1-theta*exp(R)));
B = log(exp(K) - exp(N));
C = log(exp(Y) - exp(I) - gam*exp(B));
Uc = log((1-betta*hh)/((1-hh)*exp(C)));

diff(1) = exp(L)^phi/exp(Uc) - (1-alfa)*exp(Y)/exp(L);
diff(2) = Rk - R;
