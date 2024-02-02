# RProgrammingInternship

#1: Exploratory data analysis:
• Load the dataset and the relevant libraries
• Perform data type conversion of the attributes
• Carry out the missing value analysis
The **first task** can be seen clealry in the first 35 lines of the code. 

#2: Attributes distribution and trends:
• Plot monthly distribution of the total number of bikes rented
• Plot yearly distribution of the total number of bikes rented
• Plot boxplot for outliers' analysis
The **second task** is visible form 37th line to 55th line with the output images I'll be uplopading as seperate .png files

#3: Split the dataset into train and test dataset:
This task can be seen executed from lines 57-108. This also includes creating subsets of train and test data which would be later required for creation of model using Random Forest and predicting Performance of Model on Test data.

#4: Create a model using the random forest algorithm:
This task is visible in lines 110-114. Pasting the output directly belowfrom R code:
Call:
 randomForest(formula = total_count ~ ., data = train_encoded_attributes,      importance = TRUE, ntree = 200) 
               Type of random forest: regression
                     Number of trees: 200
No. of variables tried at each split: 6

          Mean of squared residuals: 509129.4
                    % Var explained: 86.36

#5: Predict the performance of the model on the test dataset:
This task is visble in lines 116-119. Pasting the output directly below from R code:
1        2        3        4        5 
1838.933 1345.016 1506.397 1349.560 1705.230 


**All the five tasks assigned have been executed with successful outputs.**
