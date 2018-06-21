#' @export

cal_confus <- function(true_vec, pred_vec, force_diag=TRUE) {
  results <- list()
  pred_vec_sort <- sort(pred_vec, decreasing=TRUE, index.return=TRUE)

  pred_vec <- pred_vec_sort$x
  true_vec <- true_vec[pred_vec_sort$ix]

  results$TP <- cumsum(true_vec==1)
  results$FP <- cumsum(true_vec==0)
  results$FN <- sum(true_vec==1)-results$TP
  results$TN <- sum(true_vec==0)-results$FP

  results$TPR <- results$TP/(results$TP+results$FN)
  results$FPR <- results$FP/(results$FP+results$TN)
  results$PPV <- results$TP/(results$TP+results$FP)

  if (force_diag) {
    results$TPR <- c(0, results$TPR)
    results$FPR <- c(0, results$FPR)
    results$PPV <- c(results$PPV[1], results$PPV)
  }
  return(results)
}
