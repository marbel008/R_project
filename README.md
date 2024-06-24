# ECI Project

This project is about a function to estimate a bovine embryonic competence index based on the expression of eight biomarker genes.

## Project Structure
```
.
├── .gitignore
├── LICENSE
├── README.md
├── data               
│   ├── required_datasets       <- The required dataset for training the model
│   ├── query_ datasets         <- Example datasets
├── results
```

## Required R packages
library(bapred)

Enter the following if this package is not installed: 
install.packages("bapred")


## Instructions  
R and RStudio are required to be installed.
Extract the files in a known directory. 
The user should click on the .Rproj file, which will open Rstudio, and access the function by clicking on the “FormulaECI.R” file, in the Files tab. The formula requires the bapred package. 
After running the formula, the required datasets should be loaded into the environment. The users can add their own dataset to the “query_datasets” folder and change the name of the example dataset (“GSE130954_BlastoIVT_PR.txt”) to the corresponding name of the dataset. The “query_datasets” folder contains several files as examples. 
After loading the dataset of interest into the R environment, the function can be applied by running “embryo_index(data)”. The function will output a table with the calculated ECI for each sample in the query dataset. 
A word of caution is that the formula requires the expression of the eight biomarker genes to calculate the ECI. Therefore, if any sample has a zero value in any of these genes, the function will generate a warning and the sample will be removed.


## citation
cff-version: 1.2.0
title: ECI
message: >-
  If you use this software, please cite it using the
  metadata from this file.
type: software
authors:
  - given-names: Belen
    family-names: Rabaglino
    email: m.b.rabaglino@uu.nl
    affiliation: Utrecht University
  - given-names: Peter
    family-names: Hansen
    email: pjhansen@ufl.edu
    affiliation: University of Florida
abstract: >-
  This project is derived from: M. B. Rabaglino, D.
  Salilew-Wondim, A. Zolini, D. Tesfaye, M. Hoelker, P.
  Lonergan, P. Hansen. FASEB J 2023 Vol. 37 Issue 3 Pages
  e22809.

## License

This project is licensed under the terms of the [MIT License](/LICENSE).
