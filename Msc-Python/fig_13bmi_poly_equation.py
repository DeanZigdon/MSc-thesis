# figure 13 - bmi poly equation
# create a poly equation for pup BMI, adding my spring 23 & herz 22 pups to see if its statistically different
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error

ayas_bmi = pd.read_csv(r"Msc-Python\csv\ayas_bmi.csv")
x = np.arange(1, 36)  #  use days 1:35
y = ayas_bmi.iloc[:, :35].replace(0, np.nan).mean(axis=0, skipna=True).values  # discard NaN & 0 values
valid_indices = ~np.isnan(y)
x = x[valid_indices]
y = y[valid_indices]

if len(x) <= 1: # debugging
    print("not enough data points for fitting the model")
    exit()

degree = 2 # can change
coefficients, cov_matrix = np.polyfit(x, y, deg=degree, cov=True)
y_pred = np.polyval(coefficients, x) # calculate CI for the coefficients
confidence_interval = 1.96 * np.sqrt(np.sum((np.vander(x, degree + 1) @ cov_matrix) * np.vander(x, degree + 1), axis=1)) # calculate the CI for the predictions
y_pred_upper = y_pred + confidence_interval
y_pred_lower = y_pred - confidence_interval

# calc the goodness of fit metrics
sse = np.sum((y - y_pred)**2)
r_squared = 1 - sse / np.sum((y - np.mean(y))**2)
adjusted_r_squared = 1 - (1 - r_squared) * (len(y) - 1) / (len(y) - (degree + 1))
rmse = np.sqrt(mean_squared_error(y, y_pred))

'''
checkup for each day mean value
print("\nmean Values for Each Date:")
for i, mean_value in enumerate(y):
print(f"Day {i + 1}: {mean_value}")
'''
print(f"\npolynomial model (degree {degree}):")
print(f"    f(x) = {np.poly1d(coefficients)}")
print("\n95% CI for coefficients:")
for i, coef in enumerate(coefficients):
    print(f"    p{i} = {coef} +/- {1.96 * np.sqrt(cov_matrix[i, i])}")
print("\ngoodness of fit:")
print(f"  SSE: {sse:.3e}")
print(f"  R^2: {r_squared:.4f}")
print(f"  adjusted R^2: {adjusted_r_squared:.4f}")
print(f"  RMSE: {rmse:.1f}")

#plt.scatter(x, y, label='data') --source data
plt.plot(x, y_pred, color='red', label='Fitted line')
plt.fill_between(x, y_pred_upper, y_pred_lower, color='red', alpha=0.2, label='95% CI')

plt.scatter(8, 0.561607208, color='#006400', label='Mean rural', marker='^') 
plt.scatter(20, 0.569736953, color='#8B0000', label='Mean urban', marker='^')  
error_rural = 0.06  # specify the error for rural
error_urban = 0.08  # specify the error for urban

plt.text(8, 0.561607208, f'{0.561607208:.2f} ± {error_rural:.2f}', color='#006400', ha='right', va='bottom')
plt.text(20, 0.569736953, f'{0.569736953:.2f} ± {error_urban:.2f}', color='#8B0000', ha='right', va='bottom')

plt.legend(loc='lower right')
plt.xlabel('Age [Days]')
plt.ylabel('BMI value')
#plt.title(f'Spring pups BMI by age')
plt.show()
