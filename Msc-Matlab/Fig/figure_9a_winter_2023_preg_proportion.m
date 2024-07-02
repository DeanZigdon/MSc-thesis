%% figure 9a 2023 winter pregnancy proportion by colony type
data = readtable("wintercityandcountrynojuv.csv");

pregnant_data = data(data.preg_list == 1, :);
rural_data = pregnant_data(pregnant_data.type == "rural", :);
urban_data = pregnant_data(pregnant_data.type == "city", :);
unique_rural_colonies = unique(rural_data.Colony);
unique_urban_colonies = unique(urban_data.Colony);
rural_proportions = zeros(numel(unique_rural_colonies), 1);
urban_proportions = zeros(numel(unique_urban_colonies), 1);
for i = 1:numel(unique_rural_colonies)
    colony = unique_rural_colonies{i};
    pregnant_count = sum(strcmp(rural_data.Colony, colony));
    total_count = sum(strcmp(data.Colony, colony));
    rural_proportions(i) = pregnant_count / total_count;
end
for i = 1:numel(unique_urban_colonies)
    colony = unique_urban_colonies{i};
    pregnant_count = sum(strcmp(urban_data.Colony, colony));
    total_count = sum(strcmp(data.Colony, colony));
    urban_proportions(i) = pregnant_count / total_count;
end

group = [repmat("Rural", size(rural_proportions, 1), 1); repmat("Urban", size(urban_proportions, 1), 1)]; % create group var for boxplot
figure;
h = boxplot([rural_proportions; urban_proportions], group, 'Whisker', 3.5, 'Symbol', 'o', 'Colors', ['g', 'r']);
grid on;
set(gca, 'XTickLabel', {'Rural', 'Urban'}, 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Colony Type', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Pregnancy Proportion', 'FontSize', 12, 'FontWeight', 'bold');
hold on;

for i = 1:numel(unique_rural_colonies)
    x = 1;
    y = rural_proportions(i);
    colony = unique_rural_colonies{i};
    plot(x, y, 'gs', 'MarkerSize', 7, 'LineWidth', 2, 'Visible', 'on');
    text(x, y, colony, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end

for i = 1:numel(unique_urban_colonies)
    x = 2;
    y = urban_proportions(i);
    colony = unique_urban_colonies{i};
    plot(x, y, 'rs', 'MarkerSize', 7, 'LineWidth', 2, 'Visible', 'on');
    text(x, y, colony, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end
h_legend = legend('Rural', 'Urban');
set(h_legend, 'TextColor', 'k', 'FontWeight', 'bold');

[h, p, ci, stats] = ttest2(rural_proportions, urban_proportions); 
mean_rural = mean(rural_proportions, 'omitnan');
mean_urban = mean(urban_proportions, 'omitnan');

disp(['t-statistic: ' num2str(stats.tstat)]);
disp(['p-value: ' num2str(p)]);
disp(['Standard Deviation (Rural): ' num2str(std(rural_proportions, 'omitnan'))]);
disp(['Standard Deviation (Urban): ' num2str(std(urban_proportions, 'omitnan'))]);
disp(['Mean  Proportion (Rural): ' num2str(mean_rural)]);
disp(['Mean  Proportion (Urban): ' num2str(mean_urban)]);
% checkup
alpha = 0.05;
if p < alpha
    disp('There is significant difference');
else
    disp('Theres no significant difference');
end