# ECI Project

This project is about the development of a formula to estimate a bovine embryonic competence index based on the expression of eight biomarker genes.

## Project Structure
To run this project, the user needs to input the RNA sequencing file derived from an experiment using the bovine as specie. 

## Required Datasets
The function should executed using the "dataTrain.txt" file and the "Biomarker_bo "found in the datasets folder. An example dataset is inside the Example folder (both inside the data folder)

```
.
├── .gitignore
├── LICENSE
├── README.md
├── data               <- All project data, ignored by git
│   ├── datasets       <- The required dataset for training the model
│   ├── example        <- Example datasets
```

## Required R packages
library(scales)
library(DESeq2)
library(bapred)

Enter the following if (any) of these packages are not installed: 
install.packages("scales")
install.packages("bapred")

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("DESeq2")



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
