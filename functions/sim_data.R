sim_data <- function(data_specs,n){



  d <- lava::sim(data_specs,n)

  #add any additional cleaning here


  return(d)

}
