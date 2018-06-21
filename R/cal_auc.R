#' @export
#' @importFrom zoo "rollmean"

cal_auc <- function(X, Y) {
  id <- order(X)
  sum(diff(X[id])*rollmean(Y[id],2))
}