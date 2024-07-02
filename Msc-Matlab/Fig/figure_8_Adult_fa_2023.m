%% figure 8 - adult forearm length(fa) 2023
wintercountrynojuv = readtable('winter country no juv.csv');
wintercitynojuv = readtable("winter city no juv.csv");
wintercityandcountrynojuv =readtable("wintercityandcountrynojuv.csv");
springcountrynojuv = readtable("spring country no juv.csv");
springcitynojuv = readtable("spring city no juv.csv");
springcityandcountrynojuv = readtable("springcityandcountrynojuv.csv");

winter_rural = wintercountrynojuv.FA_mom;
spring_rural = springcountrynojuv.FA_mom;
winter_urban = wintercitynojuv.FA_mom;
spring_urban = springcitynojuv.FA_mom;
data = {winter_rural, winter_urban, spring_rural, spring_urban}; % combine data for all 4 boxplots
colors = ['g', 'r', 'g', 'r'];
labels = {'Rural','Urban'};
figure; 
hold on;
boxPositions = [1, 2, 4, 5]; % left space for group divide
outlierColors = {'g', 'r', 'g', 'r'}; 
legendEntries = zeros(2, 1); 

for i = 1:4
    bp = boxplot(data{i}, 'Colors', colors(i), 'positions', boxPositions(i), 'Widths', 0.2);
    if isequal(data{i}, winter_rural) || isequal(data{i}, spring_rural)
        outliers = findobj(bp, 'Tag', 'Outliers');
        set(outliers, 'MarkerEdgeColor', outlierColors{i});
    end
    legendEntries(i) = plot(NaN, NaN, 's', 'Color', colors(i), 'MarkerFaceColor', 'w', 'MarkerEdgeColor', colors(i), 'LineWidth', 2);
end
grid on;
set(gca, 'XTick', [1.5, 4.5], 'XTickLabel', {'winter','spring'}, 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Season', 'FontSize',12, 'FontWeight', 'bold'); 
ylabel('Forearm length [mm]', 'FontSize', 12, 'FontWeight', 'bold'); 
ylim([80, 105]); % better display
legend(legendEntries, {'Rural', 'Urban'}, 'FontSize', 12, 'Location', 'Best');
hold off;
