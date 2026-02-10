# TODO: make this a flowmix/flowtrend function so we don't need a separate script
# TODO: better yet, make a flowmix/flowtrend "helpers" package that contains functions 
# common to both packages, like make_cv_folds, make_iimat, plotting functions, etc.

library(dplyr)
RNGkind("L'Ecuyer-CMRG")
SEEDFILE <- "seedtab.csv"

# Cross-validation settings
cv_gridsize <- 10
nfold <- 5
nrep <- 10

nrows <- cv_gridsize^2 * (nfold + 1) * nrep

## Generate all the seeds

## Make sure the seeds have not already been generated.
if(file.exists(seedfile)) {
  stop("seedtab already exists.")
}

## Generate the random number /states/ (7 integers each)
set.seed(NULL)
s <- list(.Random.seed)
for(ii in 2:nrows){
  s[[ii]] <- parallel::nextRNGStream(s[[ii-1]])
}

s <- s %>% do.call(rbind, .)
colnames(s) <- paste0("seed", 1:7)
s <- s %>% as_tibble()

# ifold == 0 corresponds to the refit step
tab <- expand.grid(
  ialpha = 1:cv_gridsize, 
  ibeta = 1:cv_gridsize, 
  ifold = 0:nfold, 
  irep = 1:nrep
) %>% as_tibble()

seedtab <- tab %>% bind_cols(s)

## Write the table to file
write.csv(seedtab, file = SEEDFILE, row.names = FALSE)
print(paste0("Wrote table containing seeds to", SEEDFILE))
