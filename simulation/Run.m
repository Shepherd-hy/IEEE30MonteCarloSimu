function Run(commands)
% =============================================================
% Run simulation and save the feature quantities to .csv files.
% -------------------------------------------------------------
% command: a structure array containing the specifications of 
%          the simulation case. For details, see "Simulate.m".
%     command.times: times of this simulation session.
%     command.name: output file name.
% =============================================================

warning('off');
assert(isstruct(commands), "The ""command"" parameter of function ""Run"" should be a structure.")
    
% Initialize parallel computing workers
disp('Initialize parallel computing workers ...')
currDir = pwd;
mkdir(fullfile(currDir, 'workers'));
p = gcp;
spmd
    % Create temporary worker directories
    workerDir = fullfile(currDir, 'workers', ['worker_' num2str(labindex)]);
    if ~exist(workerDir, 'dir')
        mkdir(workerDir);
    end
    cd(workerDir);
    % Load the Simulink model on each worker
    try
        load_system('ieee30');
    catch
        close_system('ieee30', 0);
        load_system('ieee30');
    end
    % Initialize the parameter of the model
    InitParam();
end

% Start simulation
for i = 1:length(commands)
    command = commands(i);
    assert(isfield(command, 'times'), ...
        sprintf("The %g-st element of the ""commands"" parameter doesn't contain a field named ""times"".", i))
    assert(isfield(command, 'name'), ...
        sprintf("The %g-st element of the ""commands"" parameter doesn't contain a field named ""name"".", i))
    times = command.times;
    name = command.name;
    fprintf('Simulating case "%s" for %d times ', name, times)
    % Append simulation results to temporary files
    parfor idx = 1:times
        fid = fopen([name '.csv'], 'a');
        fprintf(fid, '%s\n', Simulate(command));
        fclose(fid);
    end
    disp(' Finished.')
end

% Finishing
spmd
    close_system('ieee30', 0);
end
delete(p);
cd(currDir);
disp('Simulation finished.');
end