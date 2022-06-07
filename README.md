# Reproducible Publications with Rstudio (Project Example)

Attention: This is NOT the lesson repository. This is the GitHub repository for the project example used in the [Introduction to Reproducible Publications with Rstudio Workshop](https://github.com/carpentries-incubator/Reproducible-Publications-with-RStudio). Learners will be required to download the project example in order to follow along. 
Our example uses an adapted version of the data paper: Nitsch, F. J., Sellitto, M., & Kalenscher, T. (2021). The effects of acute and chronic stress on choice consistency. Psychoneuroendocrinology, 131, 105289. https://doi.org/10.1016/j.psyneuen.2021.105289. The data paper along with its underlying data publicly available at: https://osf.io/6mvq7 were adapted and used for educational purposes with authors' permission.

------------------------------
## README May 19 2022

This directory contains the data and analysis scripts required
to computationally reproduce the results and plots reported
in "Nitsch, Sellitto & Kalenscher (2021). The effects
of acute and chronic stress on choice consistency." Psychoneuroendocrinology.

All provided code is written R (R version 4.0.0 (2020-04-24) -- "Arbor Day).
It requires the following packages to run analysis code:
- tidyverse 1.3.0
- stringi 1.4.6
- BayesFactor 0.9.12-4.2.
- patchwork 1.0.0

And the additional packages to render the R Markdown (.rmd) paper:
- bookdown
- tidyverse
- knitr
- rticles
- rprojroot

The structure of the directory is:

root:
- RStudio Project File
- code #Contains all runnable R script files
- data #Contains raw data
    - foodchoice_data #Contains raw data from food choice task
- output #Contain all generated output
    - data #Contains preprocessed data
    - plots #Contains all plots
- paper
    - source   # R Markdown paper file  
    - output   # paper outputs
    - bin   #Contains additional code for proper paper formatting (csl)
- README.md
- NitschEtAl2021.Rproj # R project file
- LICENSE.md
- CITATION.md

To repeat the analyses, 
1. Open the RStudio Project file.
2. Open and run analyses scripts (in order)

Note: data/foodchoice_budgetlines.csv is not required to run
analysis scripts but is for information only.

Graphic output is saved to output/plots
Data output is saved to output/data
Analysis results are saved in environment / printed to console
Paper output is saved to paper/output
paper/bin contains external files/code necessary for the proper formatting of the R Markdown paper output. 

Please see citation.md for instructions on how to cite this workshop.

Please see License.md for instructions on how to re-use this material. 

Enjoy!

PS: For questions please email ucsbcarpentry (@) ucsb.edu.

