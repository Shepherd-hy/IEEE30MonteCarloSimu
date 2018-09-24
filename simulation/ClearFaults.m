function ClearFaults(line)
% ==========================================================
% Clear faults on the specified lines.
% ----------------------------------------------------------
% line: an array containing fault line ids;
% ==========================================================

line_id = ["1-2", "1-3", "2-4", "2-5", "2-6", "3-4", "4-6", "5-7", "6-7", ...
           "6-8", "6-28", "8-28", "10-17", "10-20", "10-21", "10-22", ...
           "12-14", "12-15", "12-16", "14-15", "15-18", "15-23", "16-17", ...
           "18-19", "19-20", "21-22", "22-24", "23-24", "24-25", "25-26", ...
           "25-27", "27-29", "27-30", "29-30"];
fault_line_id = line_id(line);
for i = 1:length(line)
    fault_name = strcat("ieee30/Fault ", fault_line_id(i));
    set_param(fault_name, 'FaultA', 'off', 'FaultB', 'off', 'FaultC', 'off', 'GroundFault', 'off');
end
end

