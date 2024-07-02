# this script calculates the human population (Israeli & palestinian) per square kilometere for each bat colony by both a 5km and 15km radii (previously obtained from QGIS).
import pandas as pd
print ("5km radius calculation:") #change if needed

pop_israeli = pd.read_csv(r"Msc-Python\csv\5km & lamas.csv")
pop_israeli = pop_israeli.groupby('Name')['Pop_Total'].sum().reset_index()
pop_palestinian = pd.read_csv(r"Msc-Python\csv\5km & palestinian.csv")
pop_palestinian = pop_palestinian.groupby('Name')['pop2017'].sum().reset_index()
bufferland_5km = pd.read_csv(r"Msc-Python\csv\bufferland_5km.csv")

combined_pop_5km = pd.merge(pop_israeli, pop_palestinian, on='Name', how='outer') # merge the two df based on "Name"
combined_pop_5km['pop_combined'] = combined_pop_5km[['Pop_Total', 'pop2017']].apply(lambda row: row.sum(), axis=1) # calc the sum of "Pop_Total" and "pop2017" for each row
print(combined_pop_5km)

pop_density_5km = pd.merge(combined_pop_5km, bufferland_5km[['Name', 'area_km2']], on='Name', how='inner') # merge the bufferland_5km df with combined_pop_5km based on "Name"
# create  "5km pop_density" var with selected columns
pop_density_5km = pop_density_5km[['Name', 'pop_combined', 'area_km2']]
pop_density_5km.columns = ['Name', 'pop_combined', 'area_km2']
print(pop_density_5km)
pop_density_5km.to_csv(r".\pop_density_5km.csv", index=False)

# 15km radius calculation
print ("15km radius calc:")
pop_israeli = pd.read_csv(r"Msc-Python\csv\15km & lamas.csv")
pop_israeli = pop_israeli.groupby('Name')['Pop_Total'].sum().reset_index()
pop_palestinian = pd.read_csv(r"Msc-Python\csv\15km & palestinian.csv")
pop_palestinian = pop_palestinian.groupby('Name')['pop2017'].sum().reset_index()
bufferland_15km = pd.read_csv(r"Msc-Python\csv\bufferland_15km.csv")

combined_pop_15km = pd.merge(pop_israeli, pop_palestinian, on='Name', how='outer') # merge the two dfs by "Name" column
combined_pop_15km['pop_combined'] = combined_pop_15km[['Pop_Total', 'pop2017']].apply(lambda row: row.sum(), axis=1) # calculate the sum of "Pop_Total" and "pop2017" for each row
print(combined_pop_15km)
pop_density_15km = pd.merge(combined_pop_15km, bufferland_15km[['Name', 'area_km2']], on='Name', how='inner') # merge the bufferland_15km df with combined_pop_15km by "Name" column

# Create the "15km pop_density" var with selected columns
pop_density_15km = pop_density_15km[['Name', 'pop_combined', 'area_km2']]
pop_density_15km.columns = ['Name', 'pop_combined', 'area_km2']
print(pop_density_15km)
pop_density_15km.to_csv(r"Msc-Python\csv\pop_density_15km.csv", index=False)
