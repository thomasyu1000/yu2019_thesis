function func_policyshock(switch_model,instr)
%The function to create and run the dynare codes for policy shocks
%Before running this: generate data/debttax_0.5_ss.mat
%Input: switch_model: 'baseline' for baseline model
%                     'debttax' for the debt tax model
%                     'capreq' for the debt tax model
%       instr: instruments to vary

%Get steady state of capital requirement model as initial conditions
load data/capreq_1_ss.mat params_ss vars_ss varexo_ss;
init_vars_ss = vars_ss;

%Calculate the steady state and loading the parameters and variables
switch switch_model
    case 'baseline'
        tau = 0;
        run baseline/baseline_ss.m;
        model_path = 'baseline/baseline_policyshock_model.m';
        load data/baseline_ss.mat params_ss vars_ss varexo_ss;
    case 'debttax'
        tau = instr.tau;
        run debttax/debttax_ss.m;
        model_path = 'baseline/baseline_policyshock_model.m';
        load data/debttax_ss.mat params_ss vars_ss varexo_ss;
    case 'capreq'
        kappa_y = instr.kappa_y;
        kappa_b = instr.kappa_b;
        Vbar_ss = instr.Vbar_ss;
        run capreq/capreq_ss.m;
        model_path = 'capreq/capreq_policyshock_model.m';
        load data/capreq_ss.mat params_ss vars_ss varexo_ss;
end

%Move A and Z from variables to parameters
vars_ss = rmfield(vars_ss,{'A';'Z'});
init_vars_ss = rmfield(init_vars_ss,{'A';'Z'});
params_ss.A = 1;
params_ss.Z = 1;

params_names = fieldnames(params_ss); %Cell array of parameter names
vars_names = fieldnames(vars_ss); %Cell array of endogenous variable names that will be logged
vars_names(ismember(vars_names,'Omega')) = []; %Remove Omega (to be added manually)

nn_params = length(params_names); %Number of parameters
nn_vars = length(vars_names); %Number of endogenous variables that will be logged

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
vars_string = [vars_string 'Omega' ' '];

%Creating dynare file
cd dynare;

%Creating the '.mod' file and starting writing in it
eval(['fid = fopen(''' switch_model '_policyshock.mod'',''w'');']);

fprintf(fid,'// Dynare model file\n\n');

%Defining the parameters, exogenous and endogenous variables
fprintf(fid,['parameters ' params_string ';\n']);
fprintf(fid,['var ' vars_string ';\n']);

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

%Writing the initial conditions
fprintf(fid,'\n\ninitval;\n');
for ii=1:nn_vars
    eval(['fprintf(fid,''' vars_names{ii} '=exp(%2.8f);\n'',' 'init_vars_ss.' vars_names{ii} ');']);
end
eval(['fprintf(fid,''Omega=%2.8f;\n'',' 'init_vars_ss.Omega);']);
fprintf(fid,'end;\n'); %Ending it

%Writing the steady state endogenous variables as ending values
fprintf(fid,'\n\nendval;\n');
for ii=1:nn_vars
    eval(['fprintf(fid,''' vars_names{ii} '=exp(%2.8f);\n'',' 'vars_ss.' vars_names{ii} ');']);
end
eval(['fprintf(fid,''Omega=%2.8f;\n'',' 'vars_ss.Omega);']);
fprintf(fid,'end;\n'); %Ending it

%Checking the solution and making it calculate the steady state
fprintf(fid,'\ncheck;\n');
fprintf(fid,'\nsteady;\n');

%Solving the model
fprintf(fid,'\nsimul(periods=2000, maxit=10, no_homotopy);\n');

%Closing the dynare file
fclose(fid);
cd ..

%running the dynare file
cd dynare;
eval(['dynare ' switch_model '_policyshock.mod noclearall;']);
cd ..
