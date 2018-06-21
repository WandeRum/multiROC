#' @export
#' @importFrom magrittr "%>%"
#' @importFrom boot "boot"
#' @importFrom boot "boot.ci"

pr_auc_with_ci <- function(data, conf= 0.95, type='bca', R = 100){
  pr_res <- multi_pr(data)
  AUC_res <- unlist(pr_res$AUC) %>% data.frame()
  AUC_res$Var <- row.names(AUC_res)
  colnames(AUC_res)[1] <- "AUC"
  pr_ci_all_res <- matrix(NA, nrow(AUC_res), 4) %>% data.frame()
  colnames(pr_ci_all_res) <- c("Var", "AUC", "lower CI", "higher CI") 
  pr_ci_all_res$Var <- AUC_res$Var
  pr_ci_all_res$AUC <- AUC_res$AUC
  multi_pr_auc <- function(data, idx) {
    results <- multi_pr(data[idx, ])$AUC
    results <- unlist(results)
    return(results)
  }
  for(i in 1:nrow(AUC_res)){
    res_boot <- boot(data, statistic=multi_pr_auc, R)
    res_boot_ci <- boot.ci(res_boot, conf, type, index = i)
    pr_ci_all_res[i,3] <- res_boot_ci[[4]][1,4]
    pr_ci_all_res[i,4] <- res_boot_ci[[4]][1,5]
  }
  return(pr_ci_all_res)
}
