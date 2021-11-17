CCEI <- function(x, y, px, py, m) {
  
  #Raw values
  x <- as.numeric(x)
  y <- as.numeric(y)
  px <- as.numeric(px)
  py <- as.numeric(py)
  m <- as.numeric(m)
  
  #Normalization of prices so that px + py = 1
  #and m can be interpreted on ratio scale
  #i.e. m=2 always has twice as much
  #value as m=1 (important for CCEI)
  
  pxn = px / (px + py)
  pyn = py / (px + py)
  mn = pxn*x + pyn*y
  
  nt <- length(x)
  
  drp_mat <- matrix(0, nrow = nt, ncol = nt)
  for (i in 1:nt) {
    for (j in 1:nt) {
      if (x[j]*pxn[i] + y[j]*pyn[i] <= mn[i]) {drp_mat[i,j] <- 1}
    }
  }
  
  #Banerjee and Murphy (2006) showed that for L = 2, 
  #Garp and WGarp are equivalent.
  #Therefore, we do not need to compute transitive hull of drp_mat
  
  e <- c(1,0)
  
  for (iteration in 1:30) {
    violation <- FALSE
    CCEI <- mean(e)
    for (i in 1:nt) {
      for (j in 1:nt) {
        if (drp_mat[i,j] == 1 & x[i]*pxn[j] + y[i]*pyn[j] < mn[j] * CCEI) { violation <- TRUE}
      }
    }
    
    if (violation == TRUE) {e[1] <- CCEI} else {e[2] <- CCEI}
    CCEI <- mean(e)
  }
  
  return(CCEI)
}