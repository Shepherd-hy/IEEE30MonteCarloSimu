clc;

% Add current directory into the path
addpath(pwd);
addpath('model');
addpath('simulation');

% Load change only
load_l = struct('load', true, 'loadType', 'l', 'times', 21000, 'name', '__l_ma');
load_s = struct('load', true, 'loadType', 's', 'times', 31000, 'name', '__l_mi');
load_commands = [load_l load_s];

LINE_NUM = 34;
% Load change with one fault
fault_one_commands = repmat(struct('load', true, 'loadType', 'l', 'fault', true, 'faultLine', 0, 'times', 0, 'name', '__l_ma__f_1'), 1, 2 * LINE_NUM);
for i = 1:LINE_NUM
    if i == 22
        times = 16500;
    else
        times = 500;
    end
    fault_one_commands(2 * i - 1) = struct('load', true, 'loadType', 'l', 'fault', true, 'faultLine', i, 'times', times, 'name', ['__l_ma__f_' num2str(i)]);
    fault_one_commands(2 * i) = struct('load', true, 'loadType', 's', 'fault', true, 'faultLine', i, 'times', times, 'name', ['__l_mi__f_' num2str(i)]);
end

% % Load change with two faults
% fault_two_commands = repmat(struct('load', true, 'loadType', 'l', 'fault', true, 'faultLine', zeros(2), 'times', 0, 'name', '__l_ma__f_1_2'), 1, 2 * nchoosek(LINE_NUM, 2));
% index = 0;
% for i = 1:LINE_NUM
%     for j = (i + 1):LINE_NUM
%         index = index + 1;
%         fault_two_commands(2 * index - 1) = struct('load', true, 'loadType', 'l', 'fault', true, 'faultLine', [i, j], 'times', 100, 'name', ['__l_ma__f_' num2str(i) '-' num2str(j)]);
%         fault_two_commands(2 * index) = struct('load', true, 'loadType', 's', 'fault', true, 'faultLine', [i, j], 'times', 100, 'name', ['__l_mi__f_' num2str(i) '-' num2str(j)]);
%     end
% end

% Start simulation
Run(load_commands);
Run(fault_one_commands);
% Run(fault_two_commands);