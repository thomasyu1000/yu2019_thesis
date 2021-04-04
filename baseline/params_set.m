%Sets the baseline model parameters

switch_print = 'no';  %'test' for too many details

%Household
betta = 0.99; %Discount rate
hh = 0.815; %Habit formation parameter
phi = 0.276; %Inverse Frisch elasticity of labor supply
tau = 0; %Debt tax

%Intermediaries
theta = 0.972; %The survival probability

%Firms
alfa = 0.33; %Capital share

%Capital producers
delta = 0.025; %Depreciation rate
eta = 1.728; %Investment adjustment cost parameter

%Shocks
sigma_a = 0.01; %Size of the TFP shock
rho_a = 0.95; %Persistence of the TFP shock
sigma_z = 0.01; %Size of the capital quality shock
rho_z = 0.95; %Persistence of the capital quality shock

%Targeted moments
V_mom = 0.25; %Steady state equity-to-assets ratio
C_over_Y_mom = 0.67; %Steady state household consumption-to-GDP ratio

%Starting values for parameters
omega0 = 0.005; %Starting value of proportional starting up funds
gam0 = 0.01; %Starting value of social cost of debt

%Starting values for steady state values
K0 = 3;
L0 = 0;

%Creating a structure for the parameters
params.betta = betta;
params.hh = hh;
params.phi = phi;
params.tau = tau;
params.theta = theta;
params.alfa = alfa;
params.delta = delta;
params.eta = eta;
params.sigma_a = sigma_a;
params.rho_a = rho_a;
params.sigma_z = sigma_z;
params.rho_z = rho_z;

%Setting starting values
starting.omega0 = omega0;
starting.gam0 = gam0;
starting.K0 = K0;
starting.L0 = L0;

%Setting target moments
moments.V_mom = V_mom;
moments.C_over_Y_mom = C_over_Y_mom;

switches.switch_print = switch_print;

save ../data/params.mat params starting moments switches;
