//Baseline/debt tax policy shock model
//**********************************************************************
//Households
//**********************************************************************
//1. Marginal utility of consumption
Uc = 1/(C-hh*C(-1)) - betta*hh/(C(+1)-hh*C);

//2. Euler equation
betta*R*Lambda = 1+tau;

//3. Stochastic discount rate
Lambda = Uc(+1)/Uc;

//4. Labor supply
L^phi = Uc*W;

//**********************************************************************
//Financial Intermediaries
//**********************************************************************
//5. Equity-to-assets ratio
V = N/(Q*K);

//6. Net worth
N = theta*((Rk-R(-1))*Q(-1)*K(-1) + R(-1)*N(-1)) + omega*Q(-1)*K(-1);

//7. Debt
B = Q*K - N;

//8. No arbitrage
R = Rk(+1);

//**********************************************************************
//Firms
//**********************************************************************
//9. Return to capital
Rk = (alfa*Y/K(-1) + Z*Q*(1-delta)) / Q(-1);

//10. Production function
Y = A * K(-1)^alfa * L^(1-alfa);

//11. Labor demand
W = (1-alfa)*Y/L;

//**********************************************************************
//Capital Goods Producers
//**********************************************************************
//12. Optimal investment decision
Q = 1 + eta/2*(I/I(-1)-1)*(I/I(-1)-1) + eta*(I/I(-1)-1)*I/I(-1) - betta*Lambda*eta*(I(+1)/I-1)*(I(+1)/I)*(I(+1)/I-1)*(I(+1)/I);

//13. Capital accumulation equation
K = Z*(1-delta)*K(-1) + I;

//**********************************************************************
//Equilibrium
//**********************************************************************
//14. Aggregate resource constraint
Y = C + I + eta/2*(I/I(-1)-1)*(I/I(-1)-1)*I + gam*B;

//**********************************************************************
//Some extra variables for convenience
//**********************************************************************
//15. Welfare
Omega = log(C-hh*C(-1)) - L^(1+phi)/(1+phi) + betta*Omega(+1);

//16. Premium
prem = Rk(+1)/R;
