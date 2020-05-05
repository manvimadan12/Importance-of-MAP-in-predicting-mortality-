library(SuperLearner)
library(dplyr)
library(readr)
library(caTools)
library(glm2)
library(tidyr)
library(ROCR)
library(AUC)
library(xgboost)
library(caret)
library(vimp)
library(randomForest)

patient <- read.csv(file = 'home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/patientData.csv')
bp <- read.csv(file = 'home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset//Data/aperiodicNIBPmetrics.csv')

dataset <- inner_join( bp, patient, by = c("patientunitstayid" = "patientunitstayid"))

#checking if our dataset has duplicate records
duplicated(dataset$patientunitstayid)

#extracting duplicate elements
dataset[duplicated(dataset$patientunitstayid), ]


#removing duplicates from the dataset
dataset <- dataset[!duplicated(dataset$patientunitstayid),] #count has become half od the individual tables as both patient and bp datasets have duplicates

#handling missing values in age
dataset$age = ifelse(is.na(dataset$age),ave(dataset$age, FUN = function(x) mean(x, na.rm = 'TRUE')),dataset$age)

#changing alive and expired to 0 and 1
dataset$hospitaldischargestatus = factor(dataset$hospitaldischargestatus, levels = c('Alive','Expired'),  labels = c(1,0))

#removing missing values
dataset <- drop_na(dataset)

#checking the classifiers in the superlearner library
library(SuperLearner)
listWrappers()

# Peek at code for a model
SL.glmnet

#setting the seed to make the partition reproducible
set.seed(123)


#extracting outcome variable from the dataframe
outcome = dataset$hospitaldischargestatus
outcome_bin = as.numeric(outcome)

#creating dataframe of our exploratory variables
data = subset(dataset, select = c(MAPmin, gender, age, ethnicity, apacheadmissiondx, admissionheight, admissionweight, unitdischargelocation))


pct = 0.6
train_obs = sample(nrow(dataset), floor(nrow(data)*pct))
X_train = data[train_obs, ]
x_holdout = data[-train_obs, ]
Y_train = outcome_bin[train_obs]
Y_holdout = outcome_bin[-train_obs]

table(Y_train, useNA = "ifany")


#Fit Individual Models
# Set the seed for reproducibility.
set.seed(1)

# Fit lasso model.
sl_lasso = SuperLearner(Y = Y_train, X = X_train, family = binomial(),
                        SL.library = "SL.glmnet")

sl_lasso

# Review the elements in the SuperLearner object.
names(sl_lasso)

# Here is the raw glmnet result object:
str(sl_lasso$fitLibrary$SL.glmnet_All$object, max.level = 1)

# Fit random forest.
sl_rf = SuperLearner(Y = Y_train, X = X_train, family = binomial(),
                     SL.library = "SL.ranger")

sl_rf

# Here is the risk of the best model (discrete SuperLearner winner).
sl_rf$cvRisk[which.min(sl_rf$cvRisk)]


#Fitting multiple models

set.seed(1)
sl = SuperLearner(Y = Y_train, X = X_train, family = binomial(),
                  SL.library = c("SL.mean", "SL.glmnet", "SL.ranger"))
sl

#Review how long it took to run the SuperLearner:
sl$times$everything


#Predict on new data
# Predict back on the holdout dataset.
# onlySL is set to TRUE so we don't fit algorithms that had weight = 0, saving computation.
pred = predict(sl, x_holdout, onlySL = TRUE)

# Check the structure of this prediction object.
str(pred)

# Review the columns of $library.predict.
summary(pred$library.predict)

# Histogram of our predicted values.
library(ggplot2)
qplot(pred$pred[, 1]) + theme_minimal()

## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

# Scatterplot of original values (0, 1) and predicted values.
# Ideally we would use jitter or slight transparency to deal with overlap.
qplot(y_holdout, pred$pred[, 1]) + theme_minimal()

# Review AUC - Area Under Curve
pred_rocr = ROCR::prediction(pred$pred, y_holdout)
auc = ROCR::performance(pred_rocr, measure = "auc", x.measure = "cutoff")@y.values[[1]]
auc

#Fit ensemble with external cross-validation
set.seed(1)

# Don't have timing info for the CV.SuperLearner unfortunately.
# So we need to time it manually.

system.time({
# This will take about 2x as long as the previous SuperLearner.
cv_sl = CV.SuperLearner(Y = Y_train, X = X_train, family = binomial(),
                          # For a real analysis we would use V = 10.
                          V = 3,
                          SL.library = c("SL.mean", "SL.glmnet", "SL.ranger"))
})


# We run summary on the cv_sl object rather than simply printing the object.
summary(cv_sl)

# Review the distribution of the best single learner as external CV folds.
table(simplify2array(cv_sl$whichDiscreteSL))

# Plot the performance with 95% CIs (use a better ggplot theme).
plot(cv_sl) + theme_bw()

# Save plot to a file.
ggsave("SuperLearner.png")

#Seeing if BP is relevant in predicting mortality
result <- randomForest(X_train, 
                       Y_train,
                       mtry=5,
                       ntree=50,
                       max_depth = 30,
                       sampsize=2661,
                       do.trace=TRUE)


importance(result, type = 1)   
importance(result, type = 2)

varImpPlot(result)     

ggsave("Importance of BP in predicting mortality.png")