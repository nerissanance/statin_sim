library(targets)
packs <- c("targets",
           # "heaven",
           "foreach",
           "parallel",
           "data.table",
           "tidyverse",
           "lava",
           "ltmle",
           "future",
           "future.callr")
targets::tar_option_set(packages = packs)
#setwd("v:/Data/Workdata/706582/DanielChristensen/statins/")

#source functions from functions folder
for(f in list.files("functions",".R$",full.names=TRUE)){source(f)}


# plan(callr)
# future::plan(future::multisession, workers = 2)



list(
  tar_target(coefs,{
    coefs <- data.table::fread("./data/statin_coefficients.txt")
    return(coefs)
  }
  )
  ,tar_target(data_specs, synthesize_statins(coefs))
  ,tar_target(data,sim_data(data_specs=data_specs,
                                         n=1000
                                         ))
)
