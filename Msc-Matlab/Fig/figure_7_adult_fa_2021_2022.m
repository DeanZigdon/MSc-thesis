%% figure 7 adult forearm length(fa) 2021-2022

countryTable = readtable("tinshemet_test_adult.csv");
cityTable = readtable("herzeliya_test_adult.csv");
country = countryTable.FA_mom;
country = country(countryTable.no_outlier == 1); 
city = cityTable.FA_mom;
group = [ones(size(city)); 2 * ones(size(country))];

figure;
h = boxplot([country; city], group, 'Colors', ['g', 'r']);
grid on;
set(gca, 'XTickLabel', {'Tinshemet', 'Herzeliya'}, 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Colony', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Forearm length [mm]', 'FontSize', 12, 'FontWeight', 'bold');
outliers = findobj(h, 'Tag', 'Outliers');
set(outliers, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 2);
