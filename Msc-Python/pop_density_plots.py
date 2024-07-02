# plotting script for population density of each colony and for each colony type
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

pop_density = pd.read_csv(r"Msc-Python\csv\\final_population_density_15km.csv") # change between 5\15 km
colors = {'city': 'red', 'rural': 'green'}
ax = sns.scatterplot(x='Name', y='density', hue='type', data=pop_density, palette=colors, s=100, edgecolor='black', linewidth=0.5)
plt.grid(color='gray', linestyle='--', linewidth=0.5)
plt.gca().set_facecolor('#f5f5f5')
plt.xticks(rotation=90, fontsize=13, ha='right')
plt.yticks(fontsize=13)
plt.xlabel('Colony type', fontsize=15)
plt.ylabel('Population density (residence per sqkm)',fontsize=15)
plt.title("", fontsize=16)

legend_labels = ['Urban', 'Rural']
legend_elements = [mpatches.Patch(facecolor=color, label=label) for label, color in colors.items()]
plt.legend(handles=legend_elements, labels=legend_labels, loc='upper left')
x_tick_labels = ax.get_xticklabels()
x_tick_labels = [label.get_text() if label.get_text() != 'Center' else 'Dizengof Center' for label in x_tick_labels] # phrasing change
ax.set_xticklabels(x_tick_labels)
plt.tight_layout()
plt.show()

# plotting colony type differences
city_data = pop_density[pop_density['type'] == 'city']
rural_data = pop_density[pop_density['type'] == 'rural']
fig, ax = plt.subplots()
city_positions = [1]
rural_positions = [2]
ax.boxplot(city_data['density'], positions=city_positions, widths=0.3, patch_artist=True, boxprops=dict(facecolor='red'))
ax.boxplot(rural_data['density'], positions=rural_positions, widths=0.3, patch_artist=True, boxprops=dict(facecolor='green'))
ax.set_xticks([1, 2])
ax.set_xticklabels(['Urban', 'Rural'])
ax.set_ylabel('Population density (residence per sqkm)',fontsize=15)
ax.set_title("", fontsize=14.5)
city_patch = mpatches.Patch(color='red', label='Urban')
rural_patch = mpatches.Patch(color='green', label='Rural')
legend_labels = ['Urban', 'Rural']
legend_elements = [mpatches.Patch(facecolor=color, label=label) for label, color in colors.items()]
x_tick_labels = ax.get_xticklabels()
x_tick_labels = [label.get_text() if label.get_text() != 'Center' else 'Dizengof Center' for label in x_tick_labels]
ax.set_xticklabels(x_tick_labels)
plt.legend(handles=legend_elements, labels=legend_labels, loc='upper right')
plt.grid(color='gray', linestyle='--', linewidth=0.5)
plt.xlabel('Colony Type', fontsize=15)
plt.xticks(fontsize=13)
plt.yticks(fontsize=13)
plt.tight_layout()
plt.show()
