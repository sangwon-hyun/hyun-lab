# Find which indices in the SLURM array failed so they can be rerun 
DESTIN <- "results"

cv_gridsize <- 10
nfold <- 5 
nrep <- 10

fnames <- list.files(DESTIN, pattern = "*-cvscore.Rdata")

expected_fnames <- outer(1:cv_gridsize, 1:cv_gridsize, paste, sep = "-") |>
    outer(1:nfold, paste, sep = "-") |>
    outer(1:nrep, paste, sep = "-") |>
    as.vector() |>
    paste("cvscore.Rdata", sep = "-")

missing <- setdiff(expected_fnames, fnames)
failed_job_inds <- match(missing, expected_fnames) |>
    paste(collapse = ",")

print(failed_job_inds)
