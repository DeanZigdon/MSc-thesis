% figure 9c  pup against mom and preg proportions
data = readtable('2023colony_pregratio.csv');
rural_data = data(data.type == "rural", :);
urban_data = data(data.type == "urban", :);

group = [repmat("Rural", size(rural_data, 1), 1); repmat("Urban", size(urban_data, 1), 1)];
figure;
subplot(1, 1, 1); % row,column,subplot
boxplot([rural_data.pup_to_mom_and_preg_spring; urban_data.pup_to_mom_and_preg_spring], group, 'Whisker', 3.5, 'Symbol', 'o', 'Colors', ['g', 'r']);
grid on;
set(gca, 'XTickLabel', {'Rural', 'Urban'}, 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Colony Type', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Pup to Mothers and Pregnancy proportions', 'FontSize', 12, 'FontWeight', 'bold');
hold on;

for i = 1:min(9, size(rural_data, 1))
    x = 1;
    y = rural_data.pup_to_mom_and_preg_spring(i);
    colony = rural_data.Colony{i};
    marker = plot(x, y, 'gs', 'MarkerSize', 7, 'LineWidth', 2, 'Visible', 'on');
    text(x, y, colony, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end

for i = 1:min(9, size(urban_data, 1))
    x = 2;
    y = urban_data.pup_to_mom_and_preg_spring(i);
    colony = urban_data.Colony{i};
    marker = plot(x, y, 'rs', 'MarkerSize', 7, 'LineWidth', 2, 'Visible', 'on');
    text(x, y, colony, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end
legend('Rural', 'Urban', 'Location', 'Best');
