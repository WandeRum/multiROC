#' @export
#' @importFrom boot "boot"
#' @importFrom boot "boot.ci"

pr_ci <- function(data, conf= 0.95, type='basic', R = 100, index = 4) {
  multi_pr_auc <- function(data, idx) {
    results <- multi_pr(data[idx, ])$AUC
    results <- unlist(results)
    return(results)
  }
  res_boot <- boot(data, statistic=multi_pr_auc, R)
  res_boot_ci <- boot.ci(res_boot, conf, type, index)
  return(res_boot_ci)
}
