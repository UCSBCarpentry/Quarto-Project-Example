# README 12 May 2021

This directory contains the data and analysis scripts required
to computationally reproduce the results and plots reported
in "Nitsch, Sellitto & Kalenscher (2021). The effects
of acute and chronic stress on choice consistency." Psychoneuroendocrinology.

All provided code is written R (R version 4.0.0 (2020-04-24) -- "Arbor Day).
It requires the packages
- tidyverse 1.3.0
- stringi 1.4.6
- BayesFactor 0.9.12-4.2.
- patchwork 1.0.0

The structure of the directory is

root
  - RStudio Project File
  - analysis_scripts #Contains all runnable R script files
  - data #Contains raw data
    - foodchoice_data #Contains raw data from food choice task
  - output #Contain all generated output
    - data #Contains preprocessed data
    - plots #Contains all plots

To repeat the analyses, 
1. Open the RStudio Project file.
2. Open and run analyses scripts (in order)

Note: data/foodchoice_budgetlines.csv is not required to run
analysis scripts but is for information only.

Graphic output is saved to output/plots
Data output is saved to output/data
Analysis results are saved in environment / printed to console

Enjoy!

PS: For questions please email felix(dot)nitsch(at)hhu(dot)de or fj(dot)nitsch(at)gmail(dot)com
