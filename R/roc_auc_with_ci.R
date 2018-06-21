#' @export
#' @importFrom magrittr "%>%"
#' @importFrom boot "boot"
#' @importFrom boot "boot.ci"

roc_auc_with_ci <- function(data, conf= 0.95, type='bca', R = 100){
  roc_res <- multi_roc(data)
  AUC_res <- unlist(roc_res$AUC) %>% data.frame()
  AUC_res$Var <- row.names(AUC_res)
  colnames(AUC_res)[1] <- "AUC"
  roc_ci_all_res <- matrix(NA, nrow(AUC_res), 4) %>% data.frame()
  colnames(roc_ci_all_res) <- c("Var", "AUC", "lower CI", "higher CI") 
  roc_ci_all_res$Var <- AUC_res$Var
  roc_ci_all_res$AUC <- AUC_res$AUC
  multi_roc_auc <- function(data, idx) {
    results <- multi_roc(data[idx, ])$AUC
    results <- unlist(results)
    return(results)
  }
  for(i in 1:nrow(AUC_res)){
    res_boot <- boot(data, statistic=multi_roc_auc, R)
    res_boot_ci <- boot.ci(res_boot, conf, type, index = i)
    roc_ci_all_res[i,3] <- res_boot_ci[[4]][1,4]
    roc_ci_all_res[i,4] <- res_boot_ci[[4]][1,5]
  }
  return(roc_ci_all_res)
}
