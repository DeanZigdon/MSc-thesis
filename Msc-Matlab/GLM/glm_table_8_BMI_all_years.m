% table 8- GLM analysis of BMI for all years
GLM_data = readtable("all_seasons_data_adults - Copy.csv");
GLM_data.Reproductive_State_numeric = grp2idx(GLM_data.min_reproductive_state);

var_lists = {{'FA_mom','density_5km','density_15km','parasites','temprature_IMS','date'},}; 
response_variable = 'BMI'; 
significance_threshold = 0.55; % change if needed
groups = {'adult', '...'}; % adds suffix to avoid overwrites

for group_idx = 1:length(var_lists)
    var_list = var_lists{group_idx};
    group_name = groups{group_idx};
    significant_results = cell(0, 5);
    for r = 2:length(var_list)
        combinations = nchoosek(var_list, r);
        num_combinations = size(combinations, 1);
        for i = 1:num_combinations
            formula = [response_variable ' ~ 1 + ' strjoin(combinations(i, :), ' + ') ' + (1 | real_year )'];
            disp(['Calculating GLM with formula: ' formula]); 
            filtered_data = GLM_data
            glme = fitglme(filtered_data, formula);
            % debugging
            disp(['Fitted GLM for formula: ' formula]);
            p_values = glme.Coefficients.pValue(2:end);
            
            if all(p_values <= significance_threshold)
                log_likelihood = -0.5 * glme.LogLikelihood;
                num_params = length(glme.Coefficients.Estimate);
                aic_value = 2 * num_params - 2 * log_likelihood;
                disp('P-Values:');
                disp(num2str(p_values, '%.10'));
                numeric_predictor_variables = {'FA_mom','density_5km','density_15km','parasites','temprature_IMS','date'}; % this is the ordering of effect size # in the output.
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
                p_values_str = num2str(p_values', '%.22f ');
                p_values_str = strtrim(p_values_str);
                effect_sizes_str = num2str(effect_sizes', '%.6f ');
                effect_sizes_str = strtrim(effect_sizes_str);
                significant_results(end+1, :) = {formula, formula_combined, p_values_str, aic_value, effect_sizes_str};
                disp(['*** Combination ' formula_combined ' is significant with P-Values: ' p_values_str '***']);
            end
        end
    end
    
    results_table = cell2table(significant_results, 'VariableNames', {'Formula','Combination', 'P_Values', 'AIC', 'EffectSizes'});
    filename = ['automate_glm_results_v6_' group_name '.csv']; 
    writetable(results_table, filename);
    disp(['Results for group ' group_name ' saved to ' filename]);
end