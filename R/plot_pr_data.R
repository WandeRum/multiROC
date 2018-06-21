#' @export

plot_pr_data <- function(pr_res) {
  n_method <- length(unique(pr_res$Methods))
  n_group <- length(unique(pr_res$Groups))
  pr_res_df <- data.frame(Recall= numeric(0), Precision= numeric(0), Group = character(0), AUC = numeric(0), Method = character(0))
  for (i in 1:n_method) {
    for (j in 1:n_group) {
      temp_data_1 <- data.frame(Recall=pr_res$Recall[[i]][j],
                                Precision=pr_res$Precision[[i]][j],
                                Group=unique(pr_res$Groups)[j],
                                AUC=pr_res$AUC[[i]][j],
                                Method = unique(pr_res$Methods)[i])
      colnames(temp_data_1) <- c("Recall", "Precision", "Group", "AUC", "Method")
      pr_res_df <- rbind(pr_res_df, temp_data_1)
      
    }
    temp_data_2 <- data.frame(Recall=pr_res$Recall[[i]][n_group+1],
                              Precision=pr_res$Precision[[i]][n_group+1],
                              Group= "Macro",
                              AUC=pr_res$AUC[[i]][n_group+1],
                              Method = unique(pr_res$Methods)[i])
    temp_data_3 <- data.frame(Recall=pr_res$Recall[[i]][n_group+2],
                              Precision=pr_res$Precision[[i]][n_group+2],
                              Group= "Micro",
                              AUC=pr_res$AUC[[i]][n_group+2],
                              Method = unique(pr_res$Methods)[i])
    colnames(temp_data_2) <- c("Recall", "Precision", "Group", "AUC", "Method")
    colnames(temp_data_3) <- c("Recall", "Precision", "Group", "AUC", "Method")
    pr_res_df <- rbind(pr_res_df, temp_data_2)
    pr_res_df <- rbind(pr_res_df, temp_data_3)
  }
  return(pr_res_df)
}
