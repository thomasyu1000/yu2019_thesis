//Capital requirement model
//**********************************************************************
//Households
//**********************************************************************
//1. Marginal utility of consumption
exp(Uc) = 1/(exp(C)-hh*exp(C(-1))) - betta*hh/(exp(C(+1))-hh*exp(C));

//2. Euler equation
betta*exp(R)*exp(Lambda(+1)) = 1+tau;

//3. Stochastic discount rate
exp(Lambda) = exp(Uc)/exp(Uc(-1));

//4. Labor supply
exp(L)^phi = exp(Uc)*exp(W);

//**********************************************************************
//Financial Intermediaries
//**********************************************************************
//5. Equity-to-assets ratio
exp(V) = exp(N)/(exp(Q)*exp(K));

//6. Net worth
exp(N) = theta*((exp(Rk)-exp(R(-1)))*exp(Q(-1))*exp(K(-1)) + exp(R(-1))*exp(N(-1))) + omega*exp(Q(-1))*exp(K(-1));

//7. Debt
exp(B) = exp(Q)*exp(K) - exp(N);

//8. Capital requirement rule
V = Psi + kappa_b*B + kappa_y*Y;

//**********************************************************************
//Firms
//**********************************************************************
//9. Return to capital
exp(Rk) = (alfa*exp(Y)/exp(K(-1)) + exp(Z)*exp(Q)*(1-delta)) / exp(Q(-1));

//10. Production function
exp(Y) = exp(A) * exp(K(-1))^alfa * exp(L)^(1-alfa);

//11. Labor demand
exp(W) = (1-alfa)*exp(Y)/exp(L);

//**********************************************************************
//Capital Goods Producers
//**********************************************************************
//12. Optimal investment decision
exp(Q) = 1 + eta/2*(exp(I)/exp(I(-1))-1)^2 + eta*(exp(I)/exp(I(-1))-1)*exp(I)/exp(I(-1)) - betta*exp(Lambda(+1))*eta*(exp(I(+1))/exp(I)-1)*(exp(I(+1))/exp(I))^2;

//13. Capital accumulation equation
exp(K) = exp(Z)*(1-delta)*exp(K(-1)) + exp(I);

//**********************************************************************
//Equilibrium
//**********************************************************************
//14. Aggregate resource constraint
exp(Y) = exp(C) + exp(I) + eta/2*(exp(I)/exp(I(-1))-1)^2*exp(I) + gam*exp(B);

//**********************************************************************
//Shocks
//**********************************************************************
//15. TFP shock
A = rho_a*A(-1) - e_a;

//16. Capital quality shock
Z = rho_z*Z(-1) - e_z;

//**********************************************************************
//Some extra variables for convenience
//**********************************************************************
//17. Welfare
Omega = log(exp(C)-hh*exp(C(-1))) - exp(L)^(1+phi)/(1+phi) + betta*Omega(+1);

//18. Premium
exp(prem) = exp(Rk(+1))/exp(R);
