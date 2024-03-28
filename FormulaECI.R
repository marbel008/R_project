library(scales)
library(DESeq2)
library(bapred)

embryo_index <- function(df) {
  coeff <- c(1.527609944, 1.115131778, 1.802738337, -3.284465498, -2.35750007, -2.384129346, -1.418152098, -1.880967982)

  df_tr <- df_tr[bio$ENSEMBL, ]

  if (any(row.names(df) == bio$ENSEMBL[1]) == TRUE) {
    df <- df[bio$ENSEMBL, ]
  } else {
    if (any(row.names(df) == bio$EnsemblT[1]) == TRUE) {
      df <- df[bio$EnsemblT, ]
    } else {
      if (any(row.names(df) == bio$Symbol[1]) == TRUE) {
        df <- df[bio$Symbol, ]
      } else {
        if (any(row.names(df) == bio$Entrez[1]) == TRUE) {
          df <- df[as.character(bio$Entrez), ]
        } else {
          warning("The IDs in the dataset should be ENSEMBL, Entrez or Official Symbol")
        }
      }
    }
  }
  zero_cols <- sapply(df, function(col) any(col == 0))
  if (any(zero_cols)) {
    warning("Column(s) with zero value(s) found and will be removed: ", paste(names(df)[zero_cols], collapse = ", "))
    df <- df[, !zero_cols]
  }
  if (all(sapply(df, is.integer)) == TRUE) {
    df_t <- data.frame(varianceStabilizingTransformation(as.matrix(df), fitType = "local"))
  } else {
    if (any(df < 0, na.rm = TRUE)) {
      min_val <- min(df, na.rm = TRUE)
      df_t <- df + abs(min_val) + 1
    } else {
      df_t <- df
    }
  }
  df_sc <- data.frame(
    lapply(df_t[sapply(df_t, is.numeric)],
      rescale,
      to = c(4.056, 8.453)
    ),
    row.names = row.names(df_t)
  )

  tdf_t <- t(df_t)
  tdf_tr <- t(df_tr)

  batchtest <- as.factor(rep(1, nrow(tdf_t)))
  batchtrain <- as.factor(rep(1, nrow(tdf_tr)))
  combatparams <- ba(x = tdf_tr, y = factor(c(rep("NP", 16), rep("PR", 11))), batch = batchtrain, method = "combat")
  tdf_add <- baaddon(params = combatparams, x = tdf_t, batch = batchtest)

  df_add <- data.frame(t(tdf_add))

  df_coeff <- data.frame(sweep(df_add, 1, coeff, `*`))
  sums_coeff <- data.frame(ECI = sapply(df_coeff, function(x) sum(x) + 57.76104873))

  return(sums_coeff)
}


# required datasets can be found in /data/required_datasets
setwd("data/required_datasets")
df_tr <- read.table("Data_BlastoIVV_TRAINING.txt", header = TRUE, sep = "\t", row.names = 1)
bio <- read.table("Biomarkers_Bo.txt", header = TRUE, sep = "\t", row.names = 1)

# example datasets can be found in /data/query_datasets
setwd("../query_datasets")
data <- read.table("GSE56513_EmbryoStages.txt", header = TRUE, sep = "\t", row.names = 1)

###Only run for PCR Values (dCT between Biomarker and HouseKeeping gene)####
data <- read.table("dCT_qRTPCT_dummy.txt", header = TRUE, sep = "\t", row.names = 1)
data <- -log(data, 10)

#Output ECI
ECI <- embryo_index(data)

setwd("../../results")
write.table(ECI, "ECI_values.txt", sep = "\t", col.names = NA)

