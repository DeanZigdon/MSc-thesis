% table 4 - reproductive state winter
all_seasons_data_adults = readtable("all_seasons_data_adults - Copy.csv");
var_lists = {{'density_5km','density_15km','parasites'},}; % density_5km, density_15km, season, date, parasites, preg_ratio , FA_mom , Weight_mom,pup
response_variable = 'Reproductive_State_numeric'; % change if needed
groups = {'adult', '...'}; % adds suffix to avoid overwrites
%all_seasons_data_adults.Reproductive_State_numeric = grp2idx(all_seasons_data_adults.min_reproductive_state);

% filter options: group == 1 (spring herz21 and 22-23) / winter_group == 1 (21&23 winter for reproductive status)
all_seasons_data_adults = all_seasons_data_adults(all_seasons_data_adults.winter_group == 1, :);

for group_idx = 1:length(var_lists)
    var_list = var_lists{group_idx};
    group_name = groups{group_idx};
    significant_results = cell(0, 5); % add columns for AIC and effect size
    for r = 2:length(var_list)
        combinations = nchoosek(var_list, r);
        num_combinations = size(combinations, 1);
        for i = 1:num_combinations
            formula = [response_variable ' ~ 1 + ' strjoin(combinations(i, :), ' + ') ' + (1 | real_year)']; % change random effect when needed
            disp(['Calculating GLM with formula: ' formula]); 
            glme = fitglme(all_seasons_data_adults, formula, 'Distribution', 'binomial', 'Link', 'logit');
            p_values = glme.Coefficients.pValue(2:end);
            if any(p_values < 0.05)
                continue;
            end
            log_likelihood = -0.5 * glme.LogLikelihood;
            num_params = length(glme.Coefficients.Estimate);
            aic_value = 2 * num_params - 2 * log_likelihood;
            numeric_predictor_variables = {'density_5km','density_15km','parasites'}; % ordering output of effect size #.
            effect_sizes = zeros(1, length(numeric_predictor_variables));
            for j = 1:length(numeric_predictor_variables)
                predictor_name = numeric_predictor_variables{j};
                predictor_index = find(strcmp(glme.CoefficientNames, predictor_name));
                if ~isempty(predictor_index)
                    estimate = glme.Coefficients.Estimate(predictor_index);
                    std_dev = glme.Coefficients.SE(predictor_index);
                    effect_sizes(j) = estimate / std_dev;
                else
                    effect_sizes(j) = NaN; % debugging- set NaN if predictor not found
                end
            end
            formula_combined = strjoin(combinations(i, :), ' + ');
            p_values_str = num2str(p_values', '%.12f ');
            p_values_str = strtrim(p_values_str);
            effect_sizes_str = num2str(effect_sizes', '%.6f ');
            effect_sizes_str = strtrim(effect_sizes_str);
            significant_results(end+1, :) = {formula,formula_combined, p_values_str, aic_value, effect_sizes_str};
            disp(['*** Combination ' formula_combined ' is significant with P-Values: ' p_values_str '***']);
        end
    end

    results_table = cell2table(significant_results, 'VariableNames', {'Formula','Combination', 'P_Values', 'AIC', 'EffectSizes'});
    filename = ['automate_glm_results_v3_BINOMAL' group_name '.csv'];
    writetable(results_table, filename);
    disp(['Results for group ' group_name ' saved to ' filename]);
end