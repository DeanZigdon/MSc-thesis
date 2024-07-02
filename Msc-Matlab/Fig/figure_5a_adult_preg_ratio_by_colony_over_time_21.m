%%fig 5a- adult_preg_ratio_by_colony_over_time_21
herz_21_preg_pup_ratio = readtable('herz_2021_preg_pup_ratio.csv');
readtable('winter country no juv.csv');
tinsh_21_preg_pup_ratio = readtable('tinsh_2021_preg_pup_ratio.csv');

figure;
hold on;
grid on;
line_color = ['b''g'];
names = {"05-Jul";"20-Jul";'02-Aug';'17-Aug';'30-Aug';'14-Sep';'21-Oct';'26-Dec';'30-Jan';'27-Feb';'17-Mar';'14-Apr';'12-May';'05-Jul'};
set(gca,'xtick',[1:14],'xticklabel',names,'FontWeight','bold','FontSize',12)
%title('Pups forearm length by all colonies during the year','FontWeight','bold','FontSize',23) % change title and x-y labels accordingly
xlabel('Date','FontWeight','bold','FontSize',12);
grid on;
ylabel('Adult pregnancy proportion','FontWeight','bold','FontSize',12);
set(gca, 'Color', [0.95, 0.95, 0.95]); 

herz = herz_21_preg_pup_ratio.preg_to_tot_ratio;
tinsh = tinsh_21_preg_pup_ratio.preg_to_tot_ratio;
plot(herz, 'r-x', 'LineWidth', 1.7); % herzeliya 21
plot(tinsh, 'g-x', 'LineWidth', 1.7); % tinshemet 21


legend('Herzeliya-21', 'Tinshemet-21', 'Aseret', 'Beit Govrin', 'Bnei Brit', 'Bridge', 'Center', 'Jaffa', 'Segafim', 'Shontsino', 'Tinshemet-23', 'Location', 'northwest', 'Color', 'white');
hold off