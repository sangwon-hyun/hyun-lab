library(flowmix)
library(parallelly)
library(RhpcBLASctl)
library(magrittr)

# Set filepaths for data and outputs
DATA_FILE <- file.path("data", "MGL1704-hourly-paper.RDS")
SEEDDIR <- "seedtabs"
SEEDFILE <- "seedtab.csv"
DESTIN <- "results"

# Parallelization - how many cores? (Limited to a single node on HPC)
mc.cores <- max(availableCores() - 1, 1)

# Prevent BLAS multithreading from competing with mclapply
blas_set_num_threads(1)
omp_set_num_threads(1)

# Cross-validation settings
cv_gridsize <- 10
nfold <- 5
blocksize <- 20
max_mean_lambda <- 40
max_prob_lambda <- 2 
min_mean_lambda <- 1e-4
min_prob_lambda <- 1e-4

# Estimation settings
maxdev <- 0.5
numclust <- 10
nrep <- 10

################

# Load the data
datobj <- readRDS(file = DATA_FILE)
datobj %>% list2env(envir = .GlobalEnv) %>% invisible()

# Set random seeds and save them to a file for reproducibility
seedtab <- make_seedtab(cv_gridsize, nfold, nrep, SEEDDIR, SEEDFILE)

if(!dir.exists(DESTIN)) dir.create(DESTIN)

# Calculate lambda grid
maxres <- get_max_lambda(
  DESTIN, 
  "maxres.Rdata",
  ylist, 
  countslist, 
  X, 
  numclust, 
  maxdev, 
  max_prob_lambda,
  max_mean_lambda
)

prob_lambdas <- logspace(min = min_prob_lambda, max = maxres$alpha, length = cv_gridsize) 
mean_lambdas <- logspace(min = min_mean_lambda, max = maxres$beta, length = cv_gridsize)

# I can't remember if saving these two files is necessary, but I just do it just in case
save(prob_lambdas, file = file.path(DESTIN, "prob_lambdas.Rdata"))
save(mean_lambdas, file = file.path(DESTIN, "mean_lambdas.Rdata"))

# Define cross-validation folds
folds <- make_cv_folds(ylist, nfold, blocksize)
    
# Perform k-fold cross-validation
cv.flowmix(
  ylist = ylist, 
  countslist = countslist, 
  X = X, 
  destin = DESTIN, 
  mean_lambdas = mean_lambdas, 
  prob_lambdas = prob_lambdas, 
  iimat = NULL, 
  maxdev = maxdev, 
  numclust = numclust, 
  nfold = nfold, 
  nrep = nrep, 
  verbose = TRUE, 
  refit = FALSE, 
  save_meta = TRUE, 
  mc.cores = mc.cores, 
  blocksize = blocksize, 
  folds = folds, 
  seedtab = seedtab
)

# Refit on all data
cv.flowmix(
  ylist = ylist, 
  countslist = countslist, 
  X = X, 
  destin = DESTIN, 
  mean_lambdas = mean_lambdas, 
  prob_lambdas = prob_lambdas, 
  iimat = NULL, 
  maxdev = maxdev, 
  numclust = numclust, 
  nfold = nfold, # I believe this is ignored if refit = TRUE, but not certain, so specify just in case
  nrep = nrep, 
  verbose = TRUE, 
  refit = TRUE, 
  save_meta = FALSE, 
  mc.cores = mc.cores, 
  blocksize = blocksize, # I believe this is ignored if refit = TRUE, but not certain, so specify just in case
  folds = folds, # I believe this is ignored if refit = TRUE, but not certain, so specify just in case
  seedtab = seedtab
)

# Summarize k-fold cross-validation and refitting results
cv_summary(
  destin = DESTIN, 
  save = TRUE
)
