library(SuperLearner)
library(dplyr)
library(readr)

patient <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/patientData.csv')
bp <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/aperiodicNIBPmetrics.csv')

dataset <- inner_join( bp, patient, by = c("patientunitstayid" = "patientunitstayid"))

#checking if our dataset has duplicate records
duplicated(dataset$patientunitstayid)

#extracting duplicate elements
dataset[duplicated(dataset$patientunitstayid), ]

#removing duplicates from the dataset
dataset <- dataset[!duplicated(dataset$patientunitstayid),] #count has become half od the individual tables as both patient and bp datasets have duplicates

#checking the classifiers in the superlearner library
library(SuperLearner)
listWrappers()

#splitting the dataset into test train and validayion dataset



  