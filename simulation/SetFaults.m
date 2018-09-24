function SetFaults(line, location, type, phase)
% ==========================================================
% Set faults at different locations in the model.
% ----------------------------------------------------------
% line: an array containing fault line ids;
% location: length(head bus, fault location) / total length;
% type:  SLG - 1, LL - 2, LLG - 3, LLLG - 4;
% phase: A(AB) - 1, B(BC) - 2, C(CA) - 3, valid if type < 4.
% ==========================================================

assert(length(line) == length(location) && length(location) == length(type) && length(type) == length(phase), ...
    'The parameters of function "SetFaults" should have a same dimension.')

% Define line names and parameters
line_id = ["1-2", "1-3", "2-4", "2-5", "2-6", "3-4", "4-6", "5-7", "6-7", ...
           "6-8", "6-28", "8-28", "10-17", "10-20", "10-21", "10-22", ...
           "12-14", "12-15", "12-16", "14-15", "15-18", "15-23", "16-17", ...
           "18-19", "19-20", "21-22", "22-24", "23-24", "24-25", "25-26", ...
           "25-27", "27-29", "27-30", "29-30"];
line_R = [0.0192, 0.0452, 0.057, 0.0472, 0.0581, 0.0132, 0.0119, 0.046, 0.0267, ...
          0.012, 0.0169, 0.0636, 0.0324, 0.0936, 0.0348, 0.0727, ...
          0.123, 0.0662, 0.0945, 0.221, 0.107, 0.1, 0.0524, ...
          0.0639, 0.034, 0.0116, 0.115, 0.132, 0.189, 0.254, ...
          0.109, 0.22, 0.32, 0.24];
line_X = [0.0575, 0.165, 0.174, 0.198, 0.176, 0.0379, 0.0414, 0.116, 0.082, ...
          0.042, 0.0599, 0.2, 0.0845, 0.209, 0.0749, 0.15, ...
          0.256, 0.13, 0.199, 0.2, 0.219, 0.202, 0.192, ...
          0.129, 0.068, 0.236, 0.179, 0.27, 0.329, 0.38, ...
          0.209, 0.415, 0.603, 0.453];
line_B = 0.5 * [0.0528, 0.0408, 0.0368, 0.0148, 0.0374, 0.0084, 0.009, 0.0204, 0.017, ...
          0.009, 0.013, 0.0428, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001];

% Change fault parameters
for i = 1:length(line)
    fault_line_id = line_id(line(i));
    fault_name = strcat("ieee30/Fault ", fault_line_id);
    fault_setting = ["off", "off", "off", "off"];
    if type(i) == 1
        fault_setting(phase(i)) = "on";
        fault_setting(4) = "on";
    elseif type(i) == 2
        fault_setting(phase(i)) = "on"; 
        fault_setting(mod(phase(i), 3) + 1) = "on";
    elseif type(i) == 3
        fault_setting(phase(i)) = "on";
        fault_setting(mod(phase(i), 3) + 1) = "on";
        fault_setting(4) = "on";
    elseif type(i) == 4
        fault_setting = ["on", "on", "on", "on"];
    end
    set_param(fault_name, 'FaultA', char(fault_setting(1)), 'FaultB', char(fault_setting(2)), 'FaultC', char(fault_setting(3)), 'GroundFault', char(fault_setting(4)));
    
    fault_line_name = strcat("ieee30/Line ", fault_line_id);
    set_param(strcat(fault_line_name, "-1"), 'R', num2str(line_R(line(i)) * location(i)), 'X', num2str(line_X(line(i)) * location(i)), 'B', num2str(line_B(line(i)) * location(i)));
    set_param(strcat(fault_line_name, "-2"), 'R', num2str(line_R(line(i)) * (1 - location(i))), 'X', num2str(line_X(line(i)) * (1 - location(i))), 'B', num2str(line_B(line(i)) * (1 - location(i))));
end
end