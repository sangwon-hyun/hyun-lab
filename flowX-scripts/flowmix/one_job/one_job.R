library(flowmix) 
library(magrittr)

DATA_FILE <- file.path("data", "MGL1704-hourly-paper.RDS")
DESTIN <- "results"
SEEDFILE <- "seedtab.csv"

args <- commandArgs(trailingOnly = TRUE)
cv_step <- args[1]
arraynum <- as.integer(args[2])
stopifnot(cv_step %in% c("maxlam", "cv", "refit", "summary"))

# Load the data
datobj <- readRDS(file = DATA_FILE)
datobj %>% list2env(envir = .GlobalEnv) %>% invisible()

# Estimation settings
numclust <- 10
maxdev <- 0.5
nrep <- 10

# Cross-validation settings
cv_gridsize <- 10
nfold <- 5
blocksize <- 20
max_mean_lambda <- 40
max_prob_lambda <- 2 
min_mean_lambda <- 1e-4
min_prob_lambda <- 1e-4

if(!dir.exists(DESTIN)) dir.create(DESTIN, recursive = TRUE)

##################################

# Model Cross-Validation

# Perform the selected cross-validation step
if(cv_step == "maxlam") {            
  maxres <- get_max_lambda(
    DESTIN,
    maxres_file = "maxres.Rdata",
    ylist = ylist,
    countslist = countslist,
    X = X,
    numclust = numclust,
    maxdev = maxdev,
    max_mean_lambda = max_mean_lambda,
    max_prob_lambda = max_prob_lambda)
    
  prob_lambdas <- logspace(min = min_prob_lambda, max = maxres$alpha, length = cv_gridsize)
  mean_lambdas <-logspace(min = min_mean_lambda, max = maxres$beta, length = cv_gridsize)
                            
  save(prob_lambdas, file = file.path(DESTIN, "prob_lambdas.RData"))
  save(mean_lambdas, file = file.path(DESTIN, "mean_lambdas.RData"))

  save(
    nfold, 
    nrep, 
    cv_gridsize, 
    mean_lambdas, 
    prob_lambdas, 
    file = file.path(DESTIN, "meta.Rdata")
  )
} else if(cv_step == "cv") {
  folds <- make_cv_folds(ylist, nfold, blocksize)

  load(file.path(DESTIN, "prob_lambdas.RData"))
  load(file.path(DESTIN, "mean_lambdas.RData"))

  seedtab <- read.csv(SEEDFILE)

  iimat <- make_iimat(
    cv_gridsize, 
    nfold, 
    nrep
  )

  job <- iimat[arraynum,]

  one_job(
    ialpha = job$ialpha, 
    ibeta = job$ibeta, 
    ifold = job$ifold, 
    irep = job$irep, 
    folds = folds,
    destin = DESTIN, 
    mean_lambdas = mean_lambdas, 
    prob_lambdas = prob_lambdas, 
    numclust = numclust = numclust,
    maxdev = maxdev,
    sim = FALSE, 
    seedtab = seedtab, 
    ylist = ylist, 
    countslist = countslist, 
    X = X
  )
} else if(cv_step == "refit") { 
  load(file.path(DESTIN, "prob_lambdas.RData"))
  load(file.path(DESTIN, "mean_lambdas.RData"))

  seedtab <- read.csv(SEEDFILE)

  iimat_small <- make_iimat_small(cv_gridsize)
  job <- iimat_small[arraynum,]

  one_job_refit(
    ialpha = job$ialpha,
    ibeta = job$ibeta, 
    destin = DESTIN, 
    mean_lambdas = mean_lambdas, 
    prob_lambdas = prob_lambdas,
	  nrep = nrep,	
    numclust = numclust,
    maxdev = maxdev,
    seedtab = seedtab, 
    ylist = ylist, 
    countslist = countslist, 
    X = X
  )
} else if(cv_step == "summary") {
  cv_summary(destin = DESTIN, save = TRUE)
}
