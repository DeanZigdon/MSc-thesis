% table 10- GLM analysis of spring pup forearm length 2022-2023 + herz 22
all_seasons_pups_glm = readtable("all_seasons_pups_glm.csv"); 
var_lists = {{'density_5km','density_15km','parasites','temprature_IMS','pup_gender'}};
response_variable = 'FA_pup'; 
groups = {'PUPS', '...'}; % adds suffix to avoid overwrites


filter_condition = all_seasons_pups_glm.group == 1;
all_seasons_pups_glm = all_seasons_pups_glm(filter_condition, :);

for group_idx = 1:length(var_lists)
    var_list = var_lists{group_idx};
    group_name = groups{group_idx};
    significant_results = cell(0, 5);
    for r = 2:length(var_list)
        combinations = nchoosek(var_list, r);
        num_combinations = size(combinations, 1);
        for i = 1:num_combinations
            formula = [response_variable ' ~ ' strjoin(combinations(i, :), ' + ') ' + (1 | real_year)'];
            disp(['Calculating GLM with formula: ' formula]);
            try             
                glme = fitglme(all_seasons_pups_glm, formula);
                p_values = glme.Coefficients.pValue(2:end);
                if any(p_values > 0.05) % cahnge if needed
                    disp(['Skipping combination ' formula ' due to p-value above threshold.']);
                    continue;
                end
                log_likelihood = -0.5 * glme.LogLikelihood;
                num_params = length(glme.Coefficients.Estimate);
                aic_value = 2 * num_params - 2 * log_likelihood;
                numeric_predictor_variables = {'density_5km','density_15km','parasites','temprature_IMS','pup_gender'};
                effect_sizes = zeros(1, length(numeric_predictor_variables));
                for j = 1:length(numeric_predictor_variables)
                    predictor_name = numeric_predictor_variables{j};
                    predictor_index = find(strcmp(glme.CoefficientNames, predictor_name));
                    if ~isempty(predictor_index)
                        estimate = glme.Coefficients.Estimate(predictor_index);
                        std_dev = glme.Coefficients.SE(predictor_index);
                        effect_sizes(j) = estimate / std_dev;
                    else
                        effect_sizes(j) = NaN; % set NaN if predictor is not found
                    end
                end
                formula_combined = strjoin(combinations(i, :), ' + ');
                p_values_str = num2str(p_values', '%.15f ');
                p_values_str = strtrim(p_values_str);
                effect_sizes_str = num2str(effect_sizes', '%.6f ');
                effect_sizes_str = strtrim(effect_sizes_str);
                significant_results(end+1, :) = {formula, formula_combined, p_values_str, aic_value, effect_sizes_str};
                disp(['*** Combination ' formula_combined ' is significant with P-Values: ' p_values_str '***']);
            catch % skips nulls
                continue;
            end
        end
    end

    results_table = cell2table(significant_results, 'VariableNames', {'Formula','Combination', 'P_Values', 'AIC', 'EffectSizes'});
    filename = ['automate_glm_results_v6_' group_name '.csv'];
    writetable(results_table, filename);
    disp(['Results for group ' group_name ' saved to ' filename]);
end
