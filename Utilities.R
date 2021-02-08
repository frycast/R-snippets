## %% Utility Create config and safe save functions
create_config <- function(pmax, prepare_dataset,
                          compute_SHAP, compute_bst, compute_error,
                          save_prefix, overwrite) {
  
  config <- list(pmax = pmax, # Original: 15
                 prepare_dataset = prepare_dataset, # Original: prepare_dataset1
                 compute_SHAP = compute_SHAP,
                 compute_bst = compute_bst,
                 compute_error = compute_error,
                 overwrite = overwrite)
  
  config$save_prefix <- paste0(deparse(substitute(prepare_dataset)),
                               "_pmax",pmax)
  return(config)
}
safe_save <- function(obj, file, config) {
  file <- paste0(config$save_prefix,"_",file)
  if (!file.exists(file) | config$overwrite) {
    saveRDS(structure(obj, config = config), file = file)
  } else {
    message(deparse(substitute(obj)), " not saved")
  }
}

## %% Utility for loading and installing packages
load_packages <- Vectorize(function(package) {
  if (!require(package, character.only = T)) {
    install.packages(package)
    require(package, character.only = T)
    return(F)
  }
  return(T)
})
packages <- c("mclust", 
              "MixSim", 
              "doParallel", 
              "parallel", 
              "foreach")
load_packages(packages)

## %% combine objects in a list, where the first may be a list
cl <- function(x,...) {c(1, list(...))}

## %% save results without overwriting existing results
# Assuming no more than 100 simultaneous jobs
save_results <- function(results) {
  for (i in 1:100) {
    file <- paste0("results",i,".rds")
    if (!file.exists(file)) {
      saveRDS(results, file = file)
      return("Success")
    }
  }
  error("Unable to continue saving results")
}

## %% repeat expr with arguments until there is no error
library(futile.logger)
library(utils)
retry <- function(expr, isError=function(x) "try-error" %in% class(x), 
                  maxErrors=5, sleep=0) {
  attempts = 0
  retval = try(eval(expr))
  while (isError(retval)) {
    attempts = attempts + 1
    if (attempts >= maxErrors) {
      msg = sprintf("retry: too many retries [[%s]]\n", 
                    capture.output(str(retval)))
      flog.fatal(msg)
      stop(msg)
    } else {
      msg = sprintf("retry: error in attempt %i/%i [[%s]]\n", 
                    attempts, maxErrors, 
                    capture.output(str(retval)))
      flog.error(msg)
      warning(msg)
    }
    if (sleep > 0) Sys.sleep(sleep)
    retval = try(eval(expr))
  }
  return(retval)
}

f <- function(){
  n <- runif(1)
  if (n < 0.8) {
    stop("ya")
  }
  n
}
a <- retry({f()})


## %% Peek at a list object with regular structure
peek <- function(obj) {
  str(obj, max.level=1, vec.len=2, list.len=2)
}