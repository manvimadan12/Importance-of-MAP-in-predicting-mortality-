# Predicting_Mortality_using_BP_in_eICU_dataset
[Hack Aotearoa 2020](http://hackaotearoa.co.nz/) - This project was done to address one of the challenges in the datathon organised by the University of Auckland in collaboration with eICU dataset.


# Hypothesis
The hypothesis was that blood pressure is a better predictor of mortality than Apache score.
The hypothesis was based on the years of experience of an ICU clinician who collaborated with us on the project.

# Methodology
The clinician believed that the fluctuations in the systolic and diastolic pressures happened to predict the risk to the health of the patient better.
We did some initial analysis to see if the data can provide some insight into this.
We used superlearner package in R to try different algorithms. Random Forest seemed to work best out of all the algorithms we used in terms of accuracy.
We saw the variable importance clearly idicated that BP was more important than Apache score to predict mortality.


# Prerequisites
[RStudio](https://rstudio.com/)

[R](https://www.r-project.org/)

# Packages Used

arules

You can install the package  from CRAN as follows:

`install.packages("superLearner")`

#Results
The initial importance validated our hypothesis.
We made it to the top 10 teams in the Hackathon with our solution.

# License
[MIT](https://choosealicense.com/licenses/mit/#suggest-this-license)


