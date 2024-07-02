%%  figure 12 2023 pup age between colony types, boxplot 
all_seasons_pups_glm = readtable('all_seasons_pups_glm.csv');

data = all_seasons_pups_glm;
data_filtered = data(data.real_year == 1, :);
data_filtered = data_filtered(data_filtered.season == "spring", :);
rural_data = data_filtered(data_filtered.type == "rural", :);
city_data = data_filtered(data_filtered.type == "city", :);
weight_pup_rural = rural_data.age;
weight_pup_city = city_data.age; 

figure;
subplot(1, 1, 1);
weight_pup_combined = [weight_pup_rural; weight_pup_city];
group_labels = [repmat({'Rural'}, size(weight_pup_rural, 1), 1); repmat({'City'}, size(weight_pup_city, 1), 1)];
h = boxplot(weight_pup_combined, group_labels, 'Whisker', 3.5, 'Symbol', 'o');
colors = ['g', 'r'];
for i = 1:2
    set(h(:, i), 'Color', colors(i));  
    set(h(1, i), 'MarkerEdgeColor', colors(i));
end
ylabel('Pup age [days]', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Colony type', 'FontSize', 12, 'FontWeight', 'bold');

unique_colonies_rural = unique(rural_data.Colony);
colony_fa_pup_values_rural = zeros(size(unique_colonies_rural));
for i = 1:numel(unique_colonies_rural)
    colony_name = unique_colonies_rural{i};
    colony_data = rural_data(strcmp(rural_data.Colony, colony_name), :);
    colony_fa_pup = colony_data.age;
    mean_colony_fa_pup = mean(colony_fa_pup, 'omitnan');
    fprintf('Rural Colony: %s, Mean FA_pup: %.2f\n', colony_name, mean_colony_fa_pup);
    colony_fa_pup_values_rural(i) = mean_colony_fa_pup;
end

unique_colonies_city = unique(city_data.Colony);
colony_fa_pup_values_city = zeros(size(unique_colonies_city));
for i = 1:numel(unique_colonies_city)
    colony_name = unique_colonies_city{i};
    colony_data = city_data(strcmp(city_data.Colony, colony_name), :);
    colony_fa_pup = colony_data.age;
    mean_colony_fa_pup = mean(colony_fa_pup, 'omitnan');
    fprintf('City Colony: %s, Mean FA pup: %.2f\n', colony_name, mean_colony_fa_pup);
    colony_fa_pup_values_city(i) = mean_colony_fa_pup;
end

subplot(1, 1, 1); % returns to subplot
hold on;
x_positions = [1, 2];
scatter(x_positions(1) * ones(size(colony_fa_pup_values_rural)), colony_fa_pup_values_rural, 50, 'g', 's', 'LineWidth', 1.5); % disp mean values of rural (green)
scatter(x_positions(2) * ones(size(colony_fa_pup_values_city)), colony_fa_pup_values_city, 50, 'r', 's', 'LineWidth', 1.5); % disp mean values of urban (red)
for i = 1:numel(unique_colonies_rural)
    text(x_positions(1), colony_fa_pup_values_rural(i), unique_colonies_rural{i}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end
for i = 1:numel(unique_colonies_city)
    text(x_positions(2), colony_fa_pup_values_city(i), unique_colonies_city{i}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10);
end
xticklabels({'Rural', 'Urban'});
legend('Rural', 'Urban', 'Location', 'Best', 'FontSize', 10.5, 'FontWeight', 'bold');
grid on;

hold off;
