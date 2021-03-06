function InitParam()
% ====================================================================
% Initialize generator, load, line and fault blocks in Simulink model.
% ====================================================================

% Initialize load blocks
load_id = [2, 3, 4, 5, 7, 8, 10, 12, 14, 15, 16, ...
           17, 18, 19, 20, 21, 23, 24, 26, 29, 30];
load_P = 1.0e6 * [21.7,	2.4, 7.6, 94.2, 22.8, 30.0, 5.8, 11.2, 6.2, 8.2, ...
          3.5, 9.0, 3.2, 9.5, 2.2, 17.5, 3.2, 8.7, 3.5, 2.4, 10.6];
load_Q = 1.0e6 * [12.7, 1.2, 1.6, 19.0, 10.9, 30.0, 2.0, 7.5, 1.6, 2.5, ...
          1.8, 5.8, 0.9, 3.4, 0.7, 11.2, 1.6, 6.7, 2.3, 0.9, 1.9];

for i = 1:length(load_id)
    load_name = strcat("ieee30/Load", num2str(load_id(i)));
    set_param(load_name, 'ActivePower', num2str(load_P(i)), 'InductivePower', num2str(load_Q(i)));
end

% Initialize generator blocks
gen_id = [1, 2, 5, 8, 11, 13];
gen_bus = [0, 1, 1, 1, 1, 1];
gen_Pref = 1.0e6 * [0, 40, 0, 0, 0, 0];
gen_Qmax = 1.0e6 * [0, 50, 40, 40, 24, 24];
gen_Qmin = 1.0e6 * [0, -40, -40, -10, -6, -6];

for i = 1:length(gen_id)
    gen_name = strcat("ieee30/G", num2str(gen_id(i)));
    set_param(gen_name, 'BusType', gen_bus(i), 'Pref', num2str(gen_Pref(i)), 'Qmax', num2str(gen_Qmax(i)), 'Qmin', num2str(gen_Qmin(i)));
end

% Initialize line blocks
line_id = ["1-2", "1-3", "2-4", "2-5", "2-6", "3-4", "4-6", "5-7", "6-7", ...
           "6-8", "6-28", "8-28", "10-17", "10-20", "10-21", "10-22", ...
           "12-14", "12-15", "12-16", "14-15", "15-18", "15-23", "16-17", ...
           "18-19", "19-20", "21-22", "22-24", "23-24", "24-25", "25-26", ...
           "25-27", "27-29", "27-30", "29-30"];
line_R = 0.5 * [0.0192, 0.0452, 0.057, 0.0472, 0.0581, 0.0132, 0.0119, 0.046, 0.0267, ...
          0.012, 0.0169, 0.0636, 0.0324, 0.0936, 0.0348, 0.0727, ...
          0.123, 0.0662, 0.0945, 0.221, 0.107, 0.1, 0.0524, ...
          0.0639, 0.034, 0.0116, 0.115, 0.132, 0.189, 0.254, ...
          0.109, 0.22, 0.32, 0.24];
line_X = 0.5 * [0.0575, 0.165, 0.174, 0.198, 0.176, 0.0379, 0.0414, 0.116, 0.082, ...
          0.042, 0.0599, 0.2, 0.0845, 0.209, 0.0749, 0.15, ...
          0.256, 0.13, 0.199, 0.2, 0.219, 0.202, 0.192, ...
          0.129, 0.068, 0.236, 0.179, 0.27, 0.329, 0.38, ...
          0.209, 0.415, 0.603, 0.453];
line_B = 0.25 * [0.0528, 0.0408, 0.0368, 0.0148, 0.0374, 0.0084, 0.009, 0.0204, 0.017, ...
          0.009, 0.013, 0.0428, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, 0.0001, ...
          0.0001, 0.0001, 0.0001, 0.0001];
line_kV = [132, 132, 132, 132, 132, 132, 132, 132, 132, ...
           132, 132, 132, 33, 33, 33, 33, ...
           33, 33, 33, 33, 33, 33, 33, ...
           33, 33, 33, 33, 33, 33, 33, ...
           33, 33, 33, 33];

for i = 1:length(line_id)
    for j = 1:2
        line_name = strcat("ieee30/Line ", line_id(i), "-", num2str(j));
        set_param(line_name, 'R', num2str(line_R(i)), 'X', num2str(line_X(i)), 'B', num2str(line_B(i)), 'KV', num2str(line_kV(i)));
    end
end

% Initialize fault blocks
for i = 1:length(line_id)
    fault_name = strcat("ieee30/Fault ", line_id(i));
    set_param(fault_name, 'FaultA', 'off', 'FaultB', 'off', 'FaultC', 'off', 'GroundFault', 'off');
end

% Refresh current model
set_param('ieee30', 'SimulationCommand', 'Update');