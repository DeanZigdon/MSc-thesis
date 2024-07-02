% table 7- 2021 GLM BMI - parasites
GLM_data = readtable("first_season_data_adults");
GLM_data.Reproductive_State_numeric = grp2idx(GLM_data.min_reproductive_state);
formula = 'BMI ~ 1 + parasites + (1 | Colony)';
mdl = fitglme(GLM_data, formula, 'Distribution', 'normal', 'Link', 'identity');

disp('GLM summary:')
disp(mdl)

p_values = mdl.Coefficients.pValue;
disp('P values for each predictor:')
fprintf('parasites: %.7f\n', p_values(2));

