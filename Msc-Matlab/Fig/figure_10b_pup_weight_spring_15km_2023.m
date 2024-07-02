% figure 10b, pup weight by density spring 2023 (15km radius)
springcityandcountrynojuv = readtable("springcityandcountrynojuv.csv");
pop_density_15km = readtable("pop_density_15km.csv");

% urban 
springcityandcountrynojuv.Colony= categorical(springcityandcountrynojuv.Colony); 
i = (springcityandcountrynojuv.Colony == 'Jaffa');
spring_jaffa  = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'shontzino');
spring_shontsino = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Dizengof center');
spring_center = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Bridge');
spring_bridge = springcityandcountrynojuv(i,:);
% rural
springcityandcountrynojuv.Colony= categorical(springcityandcountrynojuv.Colony);
i = (springcityandcountrynojuv.Colony == 'Segafim');
spring_Segafim = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Beit Govrin');
spring_Beit_Govrin = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Aseret');
spring_aseret = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Bnei Brit');
spring_Bnei_Brit = springcityandcountrynojuv(i,:);
i = (springcityandcountrynojuv.Colony == 'Tinshemet');
spring_Tinshemet23= springcityandcountrynojuv(i,:);

mean_Jaffa_spring = [mean(spring_jaffa.pup_weight,"omitnan")];
mean_Shontsino_spring = [mean(spring_shontsino.pup_weight,"omitnan")];
mean_Bridge_spring = [mean(spring_bridge.pup_weight,"omitnan")];
mean_Center_spring = [mean(spring_center.pup_weight,"omitnan")];
mean_Aseret_spring = [mean(spring_aseret.pup_weight,"omitnan")];
mean_Bneibrit_spring = [mean(spring_Bnei_Brit.pup_weight,"omitnan")];
mean_BeitGovrin_spring = [mean(spring_Beit_Govrin.pup_weight,"omitnan")];
mean_Segafim_spring = [mean(spring_Segafim.pup_weight,"omitnan")];
mean_Tinshemet_spring = [mean(spring_Tinshemet23.pup_weight,"omitnan")];
each_spring_colony_mean = table(mean_Aseret_spring,mean_BeitGovrin_spring,mean_Bneibrit_spring,mean_Segafim_spring,mean_Center_spring,mean_Jaffa_spring,mean_Shontsino_spring,mean_Bridge_spring,mean_Tinshemet_spring);

each_spring_colony_mean = table(mean_Jaffa_spring', mean_Shontsino_spring', mean_Bridge_spring', mean_Center_spring', mean_Aseret_spring', mean_Bneibrit_spring', mean_BeitGovrin_spring', mean_Segafim_spring', mean_Tinshemet_spring',...
    'VariableNames', {'mean_Jaffa_spring', 'mean_Shontsino_spring', 'mean_Bridge_spring', 'mean_Center_spring', 'mean_Aseret_spring', 'mean_Bneibrit_spring', 'mean_BeitGovrin_spring', 'mean_Segafim_spring', 'mean_Tinshemet_spring'});
column_names = each_spring_colony_mean.Properties.VariableNames;
colony_names = extractBetween(column_names, "mean_", "_spring"); % deduct "mean_" and "_spring" prefixes and suffixes
colony_means = table();
season_all_colonies_mean.colony_name = colony_names';
season_all_colonies_mean.mean = each_spring_colony_mean{1, :}';
disp(season_all_colonies_mean.mean)

figure;
hold on;
grid on;
colony_colors = containers.Map(...
    {'BeitGovrin', 'Segafim', 'Tinshemet', 'Bneibrit', 'Aseret', 'Shontsino', 'Center', 'Bridge', 'Jaffa'}, ...
    1:9);  % assign numeric values for colors, wont work correctly for each colony- color otherwise
color_palette = [
    0, 0, 0.8;      % Dark Blue - Beit Govrin
    0, 0.8, 0.8;;    % Teal - Segafim
    0, 0.9, 0;      % Bright Green - Tinshemet
    0, 0.5, 0;      % Dark Green - Bnei Brit
    0.7, 0, 0.7;    % Purple - Aseret
    1, 1, 0;        % Yellow - Shontsino
    1, 0.5, 0;      % Orange - Dizengof center
    0.6, 0, 0;      % Dark Red - Bridge
    1, 0, 0;        % Red - Jaffa
];
default_color = [0.4, 0.3, 0.5]; % for missing colonies (herzeliya)
colony_names = strtrim(colony_names);
orange = [0, 0.5, 0];
for i = 1:numel(colony_names)
    colony_name = colony_names{i};
    index_density = find(strcmp(pop_density_15km.Colony, colony_name));
    index_ratio = find(strcmp(season_all_colonies_mean.colony_name, colony_name));
    if ~isempty(index_density) && ~isempty(index_ratio)
        density = pop_density_15km.density(index_density);
        spring_ratio = season_all_colonies_mean.mean(index_ratio); 
        if isKey(colony_colors, colony_name)
            color_index = colony_colors(colony_name);
            color = color_palette(color_index, :);
        else
            color = default_color;
        end
        plot(density, spring_ratio, '*', 'MarkerSize', 9, 'LineWidth', 3, 'Color', color, 'DisplayName', colony_name); 
    end
end
plot (mean_Bneibrit_spring,'*', 'MarkerSize', 9, 'LineWidth', 3, 'Color', orange, 'DisplayName', 'Bneibrit');
xlabel('Density [Humans per square kilometere]',FontWeight='bold');
ylabel('Pup weight [gr]',FontWeight='bold');
legend('Location', 'best',FontWeight='bold');
hold off;
