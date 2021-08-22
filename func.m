function func(switch_model,instr)
%The function to create and run the dynare codes for crisis simulations
%Input: switch_model: 'baseline' for baseline model
%                     'debttax' for the debt tax model
%                     'capreq' for the debt tax model
%       instr: instruments to vary

%Calculate the steady state and loading the parameters and variables
switch switch_model
    case 'baseline'
        run baseline/baseline_ss.m;
        kappa_lvls = '';
        model_path = 'baseline/baseline_model.m';
        load data/baseline_ss.mat params_ss vars_ss varexo_ss;
    case 'debttax'
        %Before running this: run baseline/baseline_ss
        tau = instr.tau;
        kappa_lvls = '';
        run debttax/debttax_ss.m;
        model_path = 'baseline/baseline_model.m';
        load data/debttax_ss.mat params_ss vars_ss varexo_ss;
    case 'capreq'
        %Before running this: run baseline/baseline_ss
        kappa_y = instr.kappa_y;
        kappa_b = instr.kappa_b;
        Vbar_ss = instr.Vbar_ss;
        kappa_lvls = ['_' num2str(kappa_b) '_' num2str(kappa_y)];
        model_path = 'capreq/capreq_model.m';
        run capreq/capreq_ss.m;
        load data/capreq_ss.mat params_ss vars_ss varexo_ss;
end
        
params_names = fieldnames(params_ss); %Cell array of parameter names
vars_names = fieldnames(vars_ss); %Cell array of endogenous variable names that will be logged
varexo_names = fieldnames(varexo_ss); %Cell array of exogenous variable names

nn_params = length(params_names); %Number of parameters
nn_vars = length(vars_names); %Number of endogenous variables that will be logged
nn_varexo = length(varexo_names); %Number of exogenous variables

%Creating a string with the parameter names
params_string = [];
for ii=1:nn_params
    params_string = [params_string params_names{ii} ' '];
end

%Creating a string with the endogenous variable names
vars_string = [];
for ii=1:nn_vars
    vars_string = [vars_string vars_names{ii} ' '];
end

%Creating a string with the exogenous variable names
varexo_string = [];
for ii=1:nn_varexo
    varexo_string = [varexo_string varexo_names{ii} ' '];
end

%Creating dynare file
cd dynare;

%Creating the '.mod' file and starting writing in it
eval(['fid = fopen(''' switch_model '.mod'',''w'');']);

fprintf(fid,'// Dynare model file\n\n');

%Defining the parameters, exogenous and endogenous variables
fprintf(fid,['parameters ' params_string ';\n']);
fprintf(fid,['var ' vars_string ';\n']);
fprintf(fid,['varexo ' varexo_string ';\n\n']);

%Writing the parameter values
for ii=1:nn_params
    eval(['fprintf(fid,''' params_names{ii} '=%2.8f;\n'',' 'params_ss.' params_names{ii} ');']);
end

%Opening the model file and copying the model into the dynare file
fprintf(fid,'\n\nmodel;\n');

%Opening the model file as readable
eval(['fid_mod = fopen(''../' model_path ''',''r'');']);

while (1>0)
    modelline = fgetl(fid_mod);
        if (modelline==-1) %End of file
            break 
        end
    fprintf(fid,[modelline '\n']);
end
fprintf(fid,'end;\n');
fclose(fid_mod); %Closing the model file

%Writing the steady state endogenous and exogenous variables as starting values
fprintf(fid,'\n\ninitval;\n');
for ii=1:nn_vars
    eval(['fprintf(fid,''' vars_names{ii} '=%2.8f;\n'',' 'vars_ss.' vars_names{ii} ');']);
end
for ii=1:nn_varexo
    eval(['fprintf(fid,''' varexo_names{ii} '=%2.8f;\n'',' 'varexo_ss.' varexo_names{ii} ');']);
end
fprintf(fid,'end;\n'); %Ending it

%Defining the variances of the shocks
fprintf(fid,'\nshocks;\n');
for ii=1:nn_varexo    
    varexo_end  = varexo_names{ii}(3:length(varexo_names{ii})); %Shock names
    eval(['fprintf(fid,''' 'var ' varexo_names{ii} '=sigma_' varexo_end '^2;\n''' ');']);
end
fprintf(fid,'end;\n');

%Checking the solution and making it calculate the steady state
fprintf(fid,'\ncheck;\n');
fprintf(fid,'\nsteady;\n');

%Solving the model
fprintf(fid,'\nstoch_simul(order=1, periods=2000, irf=40, nograph);');

%Saving the created impulse responses
fprintf(fid,'\n\n// Saving the impulse responses');
eval(['fprintf(fid,''\nsave ../data/' switch_model kappa_lvls '_irfs.mat '');']);        
for ii=1:nn_vars
    for jj=1:nn_varexo
            fprintf(fid,[vars_names{ii} '_' varexo_names{jj} ' ']);    
    end
end
fprintf(fid,';\n');

%Closing the dynare file
fclose(fid);
cd ..

%running the dynare file
cd dynare;
eval(['dynare ' switch_model '.mod noclearall;']);
pause(0.01);
cd ..
