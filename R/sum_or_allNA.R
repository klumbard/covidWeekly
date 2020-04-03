#' Sum a vector or return NA if all entries are NA
#'
#' @param x A vector containing numerics and NAs
#' @return Either the sum of non-NA elements of the input vector, or NA if all elements of the vector are NA
#' @examples
#' x1 <- c(1,2,3,NA)
#' sum_or_allNA(x1) # returns 6
#'
#' x2 <- c(NA, NA, NA, NA)
#' sum_or_allNA(x2) # returns NA

# Function that returns NA if an entire vector is NA,
# and if not returns sum( , na.rm=TRUE) of that vector
sum_or_allNA <- function(x){
  if(all(is.na(x))){
    return(NA)} else{
      return(sum(x, na.rm = TRUE))
    }
}
