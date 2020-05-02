library(SuperLearner)
library(dplyr)
library(readr)

patient <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/patientData.csv')
bp <- read.csv(file = '/home/manvi/Documents/Life_long_learning/Projects/Predicting_Mortality_using_BP_in_eICU_dataset/Data/aperiodicNIBPmetrics.csv')

dataset <- inner_join( bp, patient, by = c("patientunitstayid" = "patientunitstayid"))


