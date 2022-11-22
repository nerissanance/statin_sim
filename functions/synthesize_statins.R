#
# Daniel's statin project
#
if(FALSE){
library(targets)
library(data.table)
library(foreach)
}


synthesize_statins <- function(coefs){

  requireNamespace("lava")
  coefficients <- data.table(coefs)
  XNAMES <- names(coefficients)[-(1:2)]
  BETA <- coefficients[,-(1:2),with=0L]
  INTERCEPT <- coefficients[["(Intercept)"]]
  # empty lava model for simulation
  m <- lvm()
  distribution(m,"age") <- normal.lvm(mean=40,sd=10)
  distribution(m,"sexFemale") <- binomial.lvm(p=0.5)
  distribution(m,"ldl") <- binomial.lvm(p=0.5)

  # loop across time and variables
  for (j in 1:NROW(coefficients)){
    V <- coefficients$var[j]
    beta <- unlist(BETA[j,])
    X <- XNAMES[!is.na(beta)]
    beta <- beta[!is.na(beta)]
    # add V ~ Intercept + beta X
    distribution(m,V) <- binomial.lvm()
    intercept(m,V) <- INTERCEPT[j]
    regression(m,from=X,to=V) <- beta
  }
  class(m) <- c("synthesizeDD",class(m))
  return(m)
}


