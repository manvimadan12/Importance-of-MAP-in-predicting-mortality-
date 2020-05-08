# Importance of MAP in predicting mortality
[Hack Aotearoa 2020](http://hackaotearoa.co.nz/) - This project was done to address one of the challenges in the datathon organised by the University of Auckland in collaboration with eICU dataset.

# Dataset
The dataset present here is a pre processed extract that I received from my team while working for the Hachathon.IT is not the complete eICU dataset, nor do I have access to it after the hackathon.
There are two files in the present extract:
* [Patient Data](https://github.com/manvimadan12/Predicting_Mortality_using_BP_in_eICU_dataset/blob/master/Dataset/patientData.csv)
* [Periodic Movement of patient inside ICU](https://github.com/manvimadan12/Predicting_Mortality_using_BP_in_eICU_dataset/blob/master/Dataset/aperiodicNIBPmetrics.csv)

# Hypothesis
The hypothesis was based on the years of experience of an ICU clinician who collaborated with us on the project.The hypothesis was that MAP (Mean Arterial Pressure) is a practical indicator of patient mortality. 

# Methodology
* The clinicians believed that the Mean Arterial Pressure taken right before admission to the ICU happened to predict the risk to the health of the patient better that other metrics.
* We did some initial analysis to see if the data can provide some insight into this.We considered the demographics of the patient along with the information about the stay of the patient in ICU.
* We used superlearner package in R to try different algorithms. Random Forest seemed to work best out of all the algorithms we used in terms of accuracy.
* We saw the variable importance clearly idicated that MAP was a better indicator than othe ethnic parameters to determine mortality.


# Prerequisites
[RStudio](https://rstudio.com/)

[R](https://www.r-project.org/)

# Packages Used

arules

You can install the package  from CRAN as follows:

`install.packages("superLearner")`

# Results
The variable importance graph given in the picture below validated our hypothesis. The findings indicate that there is merit in the hypotheiss and it should be investigated further.

We made it to the top 10 teams in the Hackathon with our solution. It can partly attributed to the uniqueness of the hypothesis as we did not use any of the standard questions provided to us during the DAtathon, instead came up with a new hypothesis that leveraged the experience of the clinicians.


# License
[MIT](https://choosealicense.com/licenses/mit/#suggest-this-license)


