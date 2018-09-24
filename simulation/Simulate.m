function out = Simulate(command)
% =======================================================================
% Conduct a single round of simulation.
% -----------------------------------------------------------------------
% command: a structure array containing the specifications of the case.
%     command.load: Boolean, whether load parameters are changed;
%     command.loadType: 'l' or 's';
%     For details about load changing specifications, see "SetLoads.m".
%     -------------------------------------------------------------------
%     command.fault: Boolean, whether fault parameters are changed;
%     command.faultLine: array, fault line ids;
%     command.faultLocation: array, fault location on the line;
%     command.faultType: array, fault type;
%     command.faultPhase: array, fault phase;
%     For details about fault changing specifications, see "SetFaults.m".
% =======================================================================

assert(isstruct(command), "The ""command"" parameter of function ""Simulate"" should be a structure.")

% Speficy load settings
if isfield(command, 'load') && command.load == true
    assert(isfield(command, 'loadType'), "The ""command"" parameter doesn't contain a field named ""loadType"".")
    SetLoads(command.loadType);
end

% Refresh model and calculate load flow
set_param('ieee30', 'SimulationCommand', 'Update');  
power_loadflow('-v2', 'ieee30', 'solve');         

% Specify fault settings
if isfield(command, 'fault') && command.fault == true
    assert(isfield(command, 'faultLine'), "The ""command"" parameter doesn't contain a field named ""faultLine"".")
    n_faultLine = length(command.faultLine);
    if ~isfield(command, 'faultLocation')
        command.faultLocation = rand(1, n_faultLine);
    end
    if ~isfield(command, 'faultType')
        command.faultType = unidrnd(4, 1, n_faultLine);
    end
    if ~isfield(command, 'faultPhase')
        command.faultPhase = unidrnd(3, 1, n_faultLine);
    end
    SetFaults(command.faultLine, command.faultLocation, command.faultType, command.faultPhase);
end

% Conduct simulation and save results to database
set_param('ieee30', 'SimulationCommand', 'Update');
configSet = getActiveConfigSet('ieee30');
simOut = sim('ieee30', configSet);
out = PrintData(simOut);

% Restore fault settings
if isfield(command, 'fault') && command.fault == true
    ClearFaults(command.faultLine);
    set_param('ieee30', 'SimulationCommand', 'Update'); 
end
end