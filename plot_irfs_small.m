function plot_irfs_small(policies)
%Plotting small figures for slides
%Input: policies: 'all' for baseline vs. debt tax vs. capital requirement
%                 'capreq' for different capital requirements

%New default color order and line width
co = [0 0.4470 0.7410; %blue
      0 0 0; %black
      0.8500 0.3250 0.0980]; %orange
set(groot,'defaultAxesColorOrder',co,'defaultLineLineWidth',2);

%Get data
switch policies
    case 'all'
        l1_lab = 'Baseline'; l1 = load('data/baseline_irfs.mat');
        l2_lab = 'Debt tax'; l2 = load('data/debttax_irfs.mat');
        l3_lab = 'Cap req'; l3 = load('data/capreq_0.5_0.5_irfs.mat');
    case 'capreq'
        l1_lab = 'Cap req (\kappa_y = 0.5)'; l1 = load('data/capreq_0.5_0.5_irfs.mat');
        l2_lab = 'Cap req (\kappa_y = 2)'; l2 = load('data/capreq_0.5_2_irfs.mat');
        l3_lab = 'Cap req (\kappa_y = 5)'; l3 = load('data/capreq_0.5_5_irfs.mat');        
end

%Plot
subplot(3,3,1)
lab1 = plot(l1.Y_e_a,'-');
hold on
lab2 = plot(l2.Y_e_a,':');
hold on
lab3 = plot(l3.Y_e_a,'--');
title('Y');
ylabel('Productivity shock')

subplot(3,3,2)
plot(l1.I_e_a,'-');
hold on
plot(l2.I_e_a,':');
hold on
plot(l3.I_e_a,'--');
title('I');

subplot(3,3,3)
plot(l1.B_e_a,'-');
hold on
plot(l2.B_e_a,':');
hold on
plot(l3.B_e_a,'--');
title('B');

subplot(3,3,4)
plot(l1.Y_e_z,'-');
hold on
plot(l2.Y_e_z,':');
hold on
plot(l3.Y_e_z,'--');
title('Y');
ylabel('Capital quality shock')

subplot(3,3,5)
plot(l1.I_e_z,'-');
hold on
plot(l2.I_e_z,':');
hold on
plot(l3.I_e_z,'--');
title('I');

subplot(3,3,6)
plot(l1.B_e_z,'-');
hold on
plot(l2.B_e_z,':');
hold on
plot(l3.B_e_z,'--');
title('B');

hL = subplot(3,3,8);
axis(hL, 'off');
lgd = legend(hL, [lab1 lab2 lab3], l1_lab, l2_lab, l3_lab);
lgd.FontSize = 12;

saveas(gcf,['figures/irfs_small_' policies '.png'])

%Restore defaults
set(groot,'defaultAxesColorOrder','remove')
set(groot,'defaultLineLineWidth','remove')
