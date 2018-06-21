#' @export
#' @importFrom magrittr "%>%"
#' @importFrom magrittr "extract"
#' @importFrom magrittr "%<>%"
#' @importFrom stats "approx"

multi_pr <- function(data, force_diag=TRUE) {
  group_names <- colnames(data) %>% extract(grepl('_true', .)) %>% gsub('(.*)_true', '\\1', .)
  method_names <- colnames(data) %>% extract(grepl('_pred.*', .)) %>% 
    gsub('.*_pred_(.*)', '\\1', .) %>% unique
  y_true <- data[, grepl('_true', colnames(data))]
  colnames(y_true) %<>% gsub('_true', '', .)
  y_true %<>% .[, match(group_names, colnames(.))]
  
  res_rec <- list()
  res_pre <- list()
  res_auc <- list()
  ## For each classifier ##
  for (i in seq_along(method_names)) {
    res_rec[[i]] <- list()
    res_pre[[i]] <- list()
    res_auc[[i]] <- list()
    method <- method_names[i]
    y_pred <- data[, grepl(method, colnames(data))]
    colnames(y_pred) %<>% gsub('_pred.*', '', .)
    y_pred %<>% .[, match(group_names, colnames(.))]
    ## Reorder the pred columns ##
    for (j in seq_along(group_names)) {
      y_true_vec <- as.vector(y_true[, j])
      y_pred_vec <- as.vector(y_pred[, j])
      confus_res <- cal_confus(y_true_vec, y_pred_vec, force_diag=force_diag)
      res_rec[[i]][[j]] <- confus_res$TPR
      res_pre[[i]][[j]] <- confus_res$PPV
      res_auc[[i]][[j]] <- cal_auc(confus_res$TPR, confus_res$PPV)
    }
    names(res_rec[[i]]) <- group_names
    names(res_pre[[i]]) <- group_names
    names(res_auc[[i]]) <- group_names
    
    all_rec <- res_rec[[i]] %>% unlist %>% unique %>% sort(decreasing=T)
    all_pre <- rep(0, length(all_rec))
    for (j in seq_along(group_names)) {
      all_pre <- all_pre + approx(res_rec[[i]][[j]], res_pre[[i]][[j]], all_rec, yleft=1, yright=0)$y
    }
    all_pre <- all_pre/length(group_names)
    res_rec[[i]]$macro <- all_rec
    res_pre[[i]]$macro <- all_pre
    res_auc[[i]]$macro <- cal_auc(res_rec[[i]]$macro, res_pre[[i]]$macro)
    
    y_true_vec_bin <- as.vector(as.matrix(y_true))
    y_pred_vec_bin <- as.vector(as.matrix(y_pred))
    confus_res_bin <- cal_confus(y_true_vec_bin, y_pred_vec_bin)
    res_rec[[i]]$micro <- confus_res_bin$TPR
    res_pre[[i]]$micro <- confus_res_bin$PPV
    res_auc[[i]]$micro <- cal_auc(res_rec[[i]]$micro, res_pre[[i]]$micro)
  }
  names(res_rec) <- method_names
  names(res_pre) <- method_names
  names(res_auc) <- method_names
  return(list(Recall=res_rec, Precision=res_pre, AUC=res_auc, 
              Methods=method_names, Groups=group_names))  
}
