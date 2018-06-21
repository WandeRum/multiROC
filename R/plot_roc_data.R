#' @export

plot_roc_data <- function(roc_res) {
  n_method <- length(unique(roc_res$Methods))
  n_group <- length(unique(roc_res$Groups))
  roc_res_df <- data.frame(Specificity= numeric(0), Sensitivity= numeric(0), Group = character(0), AUC = numeric(0), Method = character(0))
  for (i in 1:n_method) {
    for (j in 1:n_group) {
      temp_data_1 <- data.frame(Specificity=roc_res$Specificity[[i]][j],
                                Sensitivity=roc_res$Sensitivity[[i]][j],
                                Group=unique(roc_res$Groups)[j],
                                AUC=roc_res$AUC[[i]][j],
                                Method = unique(roc_res$Methods)[i])
      colnames(temp_data_1) <- c("Specificity", "Sensitivity", "Group", "AUC", "Method")
      roc_res_df <- rbind(roc_res_df, temp_data_1)
      
    }
    temp_data_2 <- data.frame(Specificity=roc_res$Specificity[[i]][n_group+1],
                              Sensitivity=roc_res$Sensitivity[[i]][n_group+1],
                              Group= "Macro",
                              AUC=roc_res$AUC[[i]][n_group+1],
                              Method = unique(roc_res$Methods)[i])
    temp_data_3 <- data.frame(Specificity=roc_res$Specificity[[i]][n_group+2],
                              Sensitivity=roc_res$Sensitivity[[i]][n_group+2],
                              Group= "Micro",
                              AUC=roc_res$AUC[[i]][n_group+2],
                              Method = unique(roc_res$Methods)[i])
    colnames(temp_data_2) <- c("Specificity", "Sensitivity", "Group", "AUC", "Method")
    colnames(temp_data_3) <- c("Specificity", "Sensitivity", "Group", "AUC", "Method")
    roc_res_df <- rbind(roc_res_df, temp_data_2)
    roc_res_df <- rbind(roc_res_df, temp_data_3)
  }
  return(roc_res_df)
}
