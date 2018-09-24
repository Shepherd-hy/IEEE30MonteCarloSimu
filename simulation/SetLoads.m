function SetLoads(type)
% ==============================================================================
% Change the load and power generation parameters of the model.
% ------------------------------------------------------------------------------
% type = 'l', parameters are sampled from +-5% ~ +-50% of the rated values;
% type = 's', parameters are sampled from 0 ~ +-5% of the nominal values.
% Power generation is adjusted according to the ratio of actual and rated loads.
% ==============================================================================

assert(lower(type) == 'l' || lower(type) == 's', ...
    'The ""type"" parameter of function "SetLoads" can only be assigned as "l" or "s".')

% Change load parameters
load_id = [2, 3, 4, 5, 7, 8, 10, 12, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 26, 29, 30];
load_P_old = 1.0e6 * [21.7,	2.4, 7.6, 94.2, 22.8, 30.0, 5.8, 11.2, 6.2, 8.2, 3.5, 9.0, 3.2, 9.5, 2.2, 17.5, 3.2, 8.7, 3.5, 2.4, 10.6];
load_Q_old = 1.0e6 * [12.7, 1.2, 1.6, 19.0, 10.9, 30.0, 2.0, 7.5, 1.6, 2.5, 1.8, 5.8, 0.9, 3.4, 0.7, 11.2, 1.6, 6.7, 2.3, 0.9, 1.9];
if lower(type) == 'l'
    load_P_new = load_P_old .* (1 + sign(rand(1, length(load_id)) - 0.5) .* (0.05 + 0.45 * rand(1, length(load_id))));
    load_Q_new = load_Q_old .* (1 + sign(rand(1, length(load_id)) - 0.5) .* (0.05 + 0.45 * rand(1, length(load_id))));
elseif lower(type) == 's'
    load_P_new = load_P_old .* (1 + sign(rand(1, length(load_id)) - 0.5) .* (0.05 * rand(1, length(load_id))));
    load_Q_new = load_Q_old .* (1 + sign(rand(1, length(load_id)) - 0.5) .* (0.05 * rand(1, length(load_id))));
end
for i = 1:length(load_id)
    load_name = strcat("ieee30/Load", num2str(load_id(i)));
    set_param(load_name, 'ActivePower', num2str(load_P_new(i)), 'InductivePower', num2str(load_Q_new(i)));
end

% Change generator parameters
set_param('ieee30/G2', 'Pref', num2str(40e6 * sum(load_P_old) / sum(load_P_new)));
end