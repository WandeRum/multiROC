#' @export
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "extract"
#' @importFrom magrittr "%<>%"
#' @importFrom stats "approx"

multi_roc <- function(data, force_diag=TRUE) {
  group_names <- colnames(data) %>% extract(grepl('_true', .)) %>% gsub('(.*)_true', '\\1', .)
  method_names <- colnames(data) %>% extract(grepl('_pred.*', .)) %>%
    gsub('.*_pred_(.*)', '\\1', .) %>% unique
  y_true <- data[, grepl('_true', colnames(data))]
  colnames(y_true) %<>% gsub('_true', '', .)
  y_true %<>% .[, match(group_names, colnames(.))]

  res_sp <- list()
  res_se <- list()
  res_auc <- list()
  ## For each classifier ##
  for (i in seq_along(method_names)) {
    res_sp[[i]] <- list()
    res_se[[i]] <- list()
    res_auc[[i]] <- list()
    method <- method_names[i]
    y_pred <- data[, grepl(method, colnames(data))]
    colnames(y_pred) %<>% gsub('_pred.*', '', .)
    y_pred %<>% .[, match(group_names, colnames(.))]
    ## Reorder the pred columns ##
    for (j in seq_along(group_names)) {
      y_true_vec <- as.vector(y_true[, j])
      y_pred_vec <- as.vector(y_pred[, j])
      roc_res <- cal_confus(y_true_vec, y_pred_vec, force_diag=force_diag)
      res_sp[[i]][[j]] <- 1-roc_res$FPR
      res_se[[i]][[j]] <- roc_res$TPR
      res_auc[[i]][[j]] <- cal_auc(X=roc_res$FPR, Y=roc_res$TPR)
    }
    names(res_sp[[i]]) <- group_names
    names(res_se[[i]]) <- group_names
    names(res_auc[[i]]) <- group_names

    all_sp <- res_sp[[i]] %>% unlist %>% unique %>% sort(decreasing=TRUE)
    all_se <- rep(0, length(all_sp))
    for (j in seq_along(group_names)) {
      all_se <- all_se + approx(res_sp[[i]][[j]], res_se[[i]][[j]], all_sp, yleft=1, yright=0)$y
    }
    all_se <- all_se/length(group_names)
    res_sp[[i]]$macro <- all_sp
    res_se[[i]]$macro <- all_se
    # if (force_diag) {
    #   res_sp[[i]]$macro <- c(1, res_sp[[i]]$macro, 0)
    #   res_se[[i]]$macro <- c(0, res_se[[i]]$macro, 1)
    # }
    res_auc[[i]]$macro <- cal_auc(X=1-res_sp[[i]]$macro, Y=res_se[[i]]$macro)

    y_true_vec_bin <- as.vector(as.matrix(y_true))
    y_pred_vec_bin <- as.vector(as.matrix(y_pred))
    roc_res_bin <- cal_confus(y_true_vec_bin, y_pred_vec_bin)
    res_sp[[i]]$micro <- 1-roc_res_bin$FPR
    res_se[[i]]$micro <- roc_res_bin$TPR
    res_auc[[i]]$micro <- cal_auc(X=1-res_sp[[i]]$micro, Y=res_se[[i]]$micro)
  }
  names(res_sp) <- method_names
  names(res_se) <- method_names
  names(res_auc) <- method_names
  return(list(Specificity=res_sp, Sensitivity=res_se, AUC=res_auc,
              Methods=method_names, Groups=group_names))
}
