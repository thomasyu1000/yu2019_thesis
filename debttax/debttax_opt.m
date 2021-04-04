%Optimize the debt tax

cd ..

%Set up loop
tau_vals = [(0:0.001:gam) gam].';
nn_tau = length(tau_vals);
new_Omega = NaN(nn_tau,1);

%Loop
for ii=1:nn_tau
    instr.tau = tau_vals(ii);
    delete dynare/debttax_policyshock.mod dynare/debttax_policyshock.m dynare/debttax_policyshock_results.mat
    try
        func_policyshock('debttax',instr);
    catch ME
        disp(['Fails for tau=' num2str(tau_vals(ii))]);
        fprintf(1,', message:\n%s',ME.message);
        cd ..
        continue
    end
    new_Omega(ii) = Omega(2);
end

save data/debttax_opt.mat new_Omega tau_vals;
