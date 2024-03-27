library(scales)
library(DESeq2)
library(bapred)

#example datasets can be found in /data/examples
data <- read.table("GSE159891_dataset.txt", header = TRUE, sep = "\t", row.names = 1)

#required datasets can be found in /data/datasets
df_tr <- read.table("Data_BlastoIVV_TRAINING.txt", header = TRUE, sep = "\t", row.names = 1)
bio <- read.table("Biomarkers_Bo.txt",header = TRUE, sep = "\t", row.names = 1)

embryo_index <- function(df) {
  NP <- c(5.235414703, 5.788812359, 5.257204421, 8.028586211, 7.60773857, 7.220248291, 6.816850651, 7.581395353)
  Coeff <- c(1.527609944, 1.115131778, 1.802738337, -3.284465498, -2.35750007, -2.384129346, -1.418152098, -1.880967982)

  df_tr <- df_tr[bio$ENSEMBL,]
  
  if (any(row.names(df) == bio$ENSEMBL[1]) == TRUE) {
    df <- df[bio$ENSEMBL,]
  } else {
    if (any(row.names(df) == bio$Symbol[1]) == TRUE) {
      df <- df[bio$Symbol,]
  } else {
    if (any(row.names(df) == bio$Entrez[1]) == TRUE) {
      df <- df[bio$Entrez,]
  } else {
  warning("The IDs in the dataset should be ENSEMBL, Entrez or Official Symbol")
  }
  }
  } 
  zero_cols <- sapply(df, function(col) any(col == 0))
  if (any(zero_cols)) {
    warning("Column(s) with zero value(s) found and will be removed: ", paste(names(df)[zero_cols], collapse = ", "))
    df <- df[, !zero_cols]
  }
  if (all(sapply(df, is.integer)) == TRUE) {
    df_t <- data.frame(varianceStabilizingTransformation(as.matrix(df)))
  } else {
  if (any(df < 0, na.rm = TRUE)) {
    min_val <- min(df, na.rm = TRUE)
    df_t <- log2(df + abs(min_val) + 1)
  } else {
    df_t <- log2(df)
    }
  }
  tdf_t <- t(df_t)
  tdf_tr <- t(df_tr)
  
  batchtest <- as.factor(rep(1,nrow(tdf_t)))
  batchtrain <- as.factor(rep(1,nrow(tdf_tr)))
  combatparams <- ba(x=tdf_tr, y=factor(c(rep("NP", 16), rep("PR", 11))), batch=batchtrain, method = "combat")
  tdf_add <- baaddon(params=combatparams, x=tdf_t, batch=batchtest)
  
  df_add <- t(tdf_add)
  
  df_coeff <- data.frame(sweep(df_add, 1, Coeff, `*`))
  sums_coeff <- data.frame(ECI=sapply(df_coeff, function(x) sum(x) + 57.76104873))
  
 return(sums_coeff)
}

ECI <- embryo_index(data)

write.table(ECI, "ECI_values.txt", sep="\t", col.names=NA)


