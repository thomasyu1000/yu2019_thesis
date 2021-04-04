%The main code for "A Model of Countercyclical Macroprudential Policy"
%Thomas Yu, May 2019

clc; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crisis Simulations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Create and run dynare code for baseline model
instr_baseline = [];
func('baseline',instr_baseline);
load data/baseline_ss.mat params_ss vars_ss varexo_ss; %Get steady state values

%Create and run dynare code for debt tax model
instr_debttax.tau = params_ss.gam;
func('debttax',instr_debttax);
load data/debttax_ss.mat params_ss vars_ss varexo_ss; %Get steady state values
save data/debttax_gam_ss.mat params_ss vars_ss varexo_ss;

%Create and run dynare code for capital requirement model with various parameters
kappas = [0.5 2 5];
nn_kappas = length(kappas);
for ii = 1:nn_kappas
    eval(['instr_capreq_' num2str(ii) '.kappa_b = 0.5;']);
    eval(['instr_capreq_' num2str(ii) '.Vbar_ss = vars_ss.V;']);
    eval(['instr_capreq_' num2str(ii) '.kappa_y = ' num2str(kappas(ii)) ';']);
    eval(['func(''capreq'',instr_capreq_' num2str(ii) ');']);
    load data/capreq_ss.mat params_ss vars_ss varexo_ss;
    eval(['save data/capreq_' num2str(ii) '_ss.mat params_ss vars_ss varexo_ss;']);
end

%Plot and save IRFs
% figure(1)
% plot_irfs_small('all');
% figure(2)
% plot_irfs_small('capreq');
figure(3)
plot_irfs_big('all','A');
figure(4)
plot_irfs_big('all','Z');
figure(5)
plot_irfs_big('capreq','A');
figure(6)
plot_irfs_big('capreq','Z');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Welfare analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get initial welfare
load data/capreq_1_ss.mat vars_ss;
init_Omega = vars_ss.Omega;

%Get welfare of baseline model
func_policyshock('baseline',instr_baseline);
baseline_newOmega = Omega(2);
baseline_newC = exp((1-betta)*(baseline_newOmega-init_Omega));

%Optimize debt tax
run debttax/debttax_opt
load data/debttax_opt.mat tau_vals new_Omega;
new_C = exp((1-betta)*(new_Omega-init_Omega));

%Plot welfare for various debt taxes
figure(7)
plot(tau_vals, new_C, '-ok', 'LineWidth', 2, 'MarkerSize', 10);
xlabel('Value of \tau');
ylabel('Consumption-equivalent welfare');
saveas(gcf,'figures/opt_tau.png');

%Get welfare of best debt tax model
[debttax_newC, max_index] = max(new_C);
best_tau = tau_vals(max_index);

%Get welfare of capital requirement model with various parameters
for ii = 1:nn_kappas
    eval(['func_policyshock(''capreq'',instr_capreq_' num2str(ii) ');']);
    eval(['capreq_' num2str(ii) '_newOmega = Omega(2);']);
    eval(['capreq_' num2str(ii) '_newC = exp((1-betta)*(capreq_' num2str(ii) '_newOmega-init_Omega));']);
end

%Plot welfare of all models
figure(8)
models = categorical({'Baseline','Debt tax','Cap req, \kappa_y=0.5','Cap req, \kappa_y=2','Cap req, \kappa_y=5'});
models = reordercats(models,{'Baseline','Debt tax','Cap req, \kappa_y=0.5','Cap req, \kappa_y=2','Cap req, \kappa_y=5'});
welf = [baseline_newC debttax_newC capreq_1_newC capreq_2_newC capreq_3_newC];
b = bar(models, welf, 'LineStyle','none','FaceColor', 'flat');
b.CData = [0 0.4470 0.7410; %blue
           0.5 0.5 0.5; %gray
           0.6350 0.0780 0.1840 %maroon
           0.6350 0.0780 0.1840
           0.6350 0.0780 0.1840];
ylabel('Consumption-equivalent welfare');
ylim([0.92 1.01]);
saveas(gcf,'figures/welfare.png');
