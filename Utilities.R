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