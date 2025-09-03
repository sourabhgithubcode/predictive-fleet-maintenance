# Predictive Fleet Maintenance – Reyes Holdings Capstone Project

This project was developed as part of a graduate-level capstone in Business Analytics at DePaul University. It focuses on using predictive analytics and clustering techniques to optimize fleet maintenance strategies for Reyes Holdings, one of the largest fleet operators in North America.

##  Objective

To identify high-cost maintenance assets and recommend data-driven strategies to reduce repair costs, improve asset utilization, and extend vehicle life using historical work order data.

## Key Features

- Built a **Random Forest** classification model to flag high-cost work orders (top 10% by total cost)
- Achieved **98% prediction accuracy** on testing data using engineered features like mileage ratio, asset age, and usage patterns
- Developed **clustering models** to segment assets into strategy buckets: "Replace", "Monitor Closely", and "Maintain"
- Created an interactive **R Shiny dashboard** for company-wide visibility and actionable insights (Link: https://6kk2xw-sourabh-rodagi.shinyapps.io/fleet_dashboard/)
- Highlighted **$800M+ in cost-saving opportunities** based on asset-level segmentation

##  Tech Stack

- **Language**: R (Tidyverse, randomForest, cluster)
- **Dashboard**: R Shiny
- **Data Processing**: dplyr, tidyr
- **Visualization**: ggplot2
- **Data Size**: 134,000+ fleet work orders with metadata, financials, and usage logs

##  Folder Structure

predictive-fleet-maintenance/
├── data/ # Sample or cleaned datasets (anonymized)
├── scripts/ # R scripts for data cleaning, modeling, clustering
├── dashboard/ # R Shiny code and UI for final visualization
├── figures/ # Charts and exported graphs
├── README.md # Project summary
└── report.pdf # Final business-facing capstone report


##  Impact

This project demonstrates the application of predictive analytics and operations strategy in a real-world enterprise fleet scenario. The results enable targeted interventions to lower maintenance spend and improve vehicle lifecycle management.

##  Author

**Sourabh R Rodagi**  
M.S. Business Analytics, DePaul University  
[LinkedIn](https://www.linkedin.com/in/sourabh-rodagi/) | [Email](mailto:srodagi@depaul.edu)

