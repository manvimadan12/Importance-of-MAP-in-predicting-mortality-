library(SuperLearner)
library(dplyr)
library(readr)
library(caTools)
library(glm2)
library(tidyr)
library(ROCR)
library(AUC)
library(xgboost)

patient <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/patientData.csv')
bp <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/aperiodicNIBPmetrics.csv')

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


#setting the seed to make the partition reproducible
set.seed(123)

#splitting the dataset into test and train and validation dataset
#splitSample <- sample(1:3, size=nrow(dataset), prob=c(0.7,0.15,0.15), replace = TRUE)
#train.hex <- dataset[splitSample==1, ]
#valid.hex <- dataset[splitSample==2, ]
#test.hex <- dataset[splitSample==3,]

#extracting outcome variable from the dataframe
outcome = dataset$hospitaldischargestatus
outcome_bin = as.numeric(outcome)

#creating dataframe of our exploratory variables
data = subset(dataset, select = c(MAPstd, gender, age, ethnicity, apacheadmissiondx, admissionheight, admissionweight, unitdischargelocation, ))


pct = 0.6
train_obs = sample(nrow(dataset), floor(nrow(data)*pct))
X_train = data[train_obs, ]
x_holdout = data[-train_obs, ]
Y_train = outcome_bin[train_obs]
Y_holdout = outcome_bin[-train_obs]

table(Y_train, useNA = "ifany")


#Fit Base Learners

#GLM
sl_glm = SuperLearner(Y = Y_train, X = X_train, family = binomial(), SL.library = "SL.glmnet")
sl_glm

pred_glm = predict(sl_glm, x_holdout)



#RANDOM FOREST
sl_randomForest = SuperLearner(Y = Y_train, X = X_train, family = binomial(), SL.library = "SL.randomForest")
sl_randomForest

pred_random = predict(sl_randomForest, x_holdout)



