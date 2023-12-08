# Reproducible Publications with Rstudio (Project Example)

*Attention!* This is NOT the lesson repository. This is the GitHub repository for the project example used in the [Introduction to Reproducible Publications with Rstudio Workshop](https://github.com/carpentries-incubator/Reproducible-Publications-with-RStudio). Learners will be required to download the project example in order to follow along. 

**The project example folder is a simplified version of the original project available at: https://osf.io/6mvq7.**

Our example uses an adapted version of the data paper: Nitsch, F. J., Sellitto, M., & Kalenscher, T. (2021). The effects of acute and chronic stress on choice consistency. Psychoneuroendocrinology, 131, 105289. https://doi.org/10.1016/j.psyneuen.2021.105289. The data paper along with its underlying data publicly available at: https://osf.io/6mvq7 were adapted and used for educational purposes with the authors' permission.

------------------------------
## README

This directory contains the data and analysis scripts required to computationally reproduce some of the results and plots reported
in "Nitsch, Sellitto & Kalenscher (2021). The effects of acute and chronic stress on choice consistency." Psychoneuroendocrinology that are used in this workshop.

All provided code is written in R (R version 4.0.0 (2020-04-24) -- "Arbor Day") and should work with more recent versions. 
It requires the following packages to run the analysis code:
- tidyverse - 1.3.2
- stringi - 1.7.8
- bayesFactor - 0.9.12-4.5
- patchwork - 1.1.3

The structure of the directory is:

root:

- `Reproducible-Publications-with-RStudio-Example.Rproj` # RStudio Project File
- `code` #Contains all runnable R script files
- `data` 
    - `processed`  # Contains processed data
    - `raw`      # Contains raw data
        - `foodchoice_data`  # Contains raw data from food choice task
- `output` # Contain all generated output
- `report`
    - `DataPaper-ReproducibilityWorkshop_files`   # Rendered files  
    - `fig`   # paper figures
- `LICENSE.md`
- `CITATION.md`
- `README.md`
- `_quarto.yml`

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

