%% fig 5b-pup_to_mother_and_preg_proportion_21_22
herz_21_preg_pup_ratio = readtable('herz_2021_preg_pup_ratio.csv');
readtable('winter country no juv.csv');
tinsh_21_preg_pup_ratio = readtable('tinsh_2021_preg_pup_ratio.csv');
figure;
hold on;
grid on;

line_color = ['b''g'];
names = {"05-Jul";"20-Jul";'02-Aug';'17-Aug';'30-Aug';'14-Sep';'21-Oct';'26-Dec';'30-Jan';'27-Feb';'17-Mar';'14-Apr';'12-May';'05-Jul'};
set(gca,'xtick',[1:14],'xticklabel',names,'FontWeight','bold','FontSize',14)
%title('Pups forearm length by all colonies during the year','FontWeight','bold','FontSize',23) % change title and x-y labels accordingly
xlabel('Date','FontWeight','bold','FontSize',13);
grid on;
ylabel('proportion of pups to mothers and pregnant individuals','FontWeight','bold','FontSize',13);
set(gca, 'Color', [0.95, 0.95, 0.95]);

readtable('winter country no juv.csv');
herz = herz_21_preg_pup_ratio.pup_to_mom_and_preg;
tinsh = tinsh_21_preg_pup_ratio.pup_to_mom_and_preg;
colonyparasitesratio = readtable('2023colony_parasites_ratio.csv');
plot(herz, 'r-x', 'LineWidth', 1.7); % herzeliya 21
plot(tinsh, 'g-x', 'LineWidth', 1.7); % tinshemet 21
legend('Herzeliya-21', 'Tinshemet-21', 'Aseret', 'Beit Govrin', 'Bnei Brit', 'Bridge', 'Center', 'Jaffa', 'Segafim', 'Shontsino', 'Tinshemet-23', 'Location', 'northwest', 'Color', 'white');
hold off