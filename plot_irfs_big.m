function plot_irfs_big(policies,shock)
%Plotting big figures for paper
%Input: policies: 'all' for baseline vs. debt tax vs. capital requirement
%                 'capreq' for different capital requirements
%       shock: 'A' for productivity shock
%              'Z' for capital quality shock

%Get data
switch policies
    case 'all'
        l1_lab = 'Baseline'; l1 = load('data/baseline_irfs.mat');
        l2_lab = 'Debt tax'; l2 = load('data/debttax_irfs.mat');
        l3_lab = 'Cap. req.'; l3 = load('data/capreq_0.5_0.5_irfs.mat');
        co = [0 0.4470 0.7410; %blue
              0 0 0; %black
              0.6350 0.0780 0.1840]; %maroon
    case 'capreq'
        l1_lab = 'Cap. req. (\kappa_y = 0.5)'; l1 = load('data/capreq_0.5_0.5_irfs.mat');
        l2_lab = 'Cap. req. (\kappa_y = 2)'; l2 = load('data/capreq_0.5_2_irfs.mat');
        l3_lab = 'Cap. req. (\kappa_y = 5)'; l3 = load('data/capreq_0.5_5_irfs.mat');        
        co = [0.4660 0.6740 0.1880; %green
              0 0 0; %black
              0.8500 0.3250 0.0980]; %orange
end

%New default color order and line width
set(groot,'defaultAxesColorOrder',co,'defaultLineLineWidth',2);

%Lower-case shock
switch shock
    case 'A'
        shock_lc = 'a';
    case 'Z'
        shock_lc = 'z';
end

%Plot
subplot(4,3,1)
eval(['lab1 = plot(l1.' shock '_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['lab2 = plot(l2.' shock '_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['lab3 = plot(l3.' shock '_e_' shock_lc ',' '''--''' ');']);
title(shock);

subplot(4,3,2)
eval(['plot(l1.Y_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.Y_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.Y_e_' shock_lc ',' '''--''' ');']);
title('Y');

subplot(4,3,3)
eval(['plot(l1.C_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.C_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.C_e_' shock_lc ',' '''--''' ');']);
title('C');

subplot(4,3,4)
eval(['plot(l1.I_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.I_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.I_e_' shock_lc ',' '''--''' ');']);
title('I');

subplot(4,3,5)
eval(['plot([0; l1.K_e_' shock_lc '(1:end-1)],' '''-''' ');']);
hold on
eval(['plot([0; l2.K_e_' shock_lc '(1:end-1)],' ''':''' ');']);
hold on
eval(['plot([0; l3.K_e_' shock_lc '(1:end-1)],' '''--''' ');']);
title('K');

subplot(4,3,6)
eval(['plot(l1.Q_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.Q_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.Q_e_' shock_lc ',' '''--''' ');']);
title('Q');

subplot(4,3,7)
eval(['plot(l1.B_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.B_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.B_e_' shock_lc ',' '''--''' ');']);
title('B');

subplot(4,3,8)
eval(['plot(l1.N_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.N_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.N_e_' shock_lc ',' '''--''' ');']);
title('N');

subplot(4,3,9)
eval(['plot(l1.V_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.V_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.V_e_' shock_lc ',' '''--''' ');']);
title('V');

subplot(4,3,10)
eval(['plot(l1.R_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.R_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.R_e_' shock_lc ',' '''--''' ');']);
title('R');

subplot(4,3,11)
eval(['plot(l1.prem_e_' shock_lc ',' '''-''' ');']);
hold on
eval(['plot(l2.prem_e_' shock_lc ',' ''':''' ');']);
hold on
eval(['plot(l3.prem_e_' shock_lc ',' '''--''' ');']);
title('E[Rk]/R');

hL = subplot(4,3,12);
axis(hL, 'off');
lgd = legend(hL, [lab1 lab2 lab3], l1_lab, l2_lab, l3_lab);
lgd.FontSize = 10;

saveas(gcf,['figures/irfs_big_' policies '_' shock '.png'])

%Restore defaults
set(groot,'defaultAxesColorOrder','remove')
set(groot,'defaultLineLineWidth','remove')
