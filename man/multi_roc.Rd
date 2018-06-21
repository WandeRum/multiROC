\name{multi_roc}
\alias{multi_roc}
\title{Multi-class classification ROC}
\description{
This function calculates the Specificity, Sensitivity and AUC of multi-class classifications.
}
\usage{
multi_roc(data, force_diag=TRUE)
}
\arguments{
\item{data}{A data frame contain true labels of multiple groups and corresponding predictive scores}
\item{force_diag}{If TRUE, TPR and FPR will be forced to across (0, 0) and (1, 1)}
}
\details{
A data frame is required for this function as input. This data frame should contains true label (0 - Negative, 1 - Positive) columns named as XX_true (e.g. S1_true, S2_true and S3_true) and predictive scores (continuous) columns named as XX_pred_YY (e.g. S1_pred_SVM, S2_pred_RF), thus this function allows calcluating ROC on mulitiple classifiers.

Predictive scores could be probabilities among [0, 1] and other continuous values.
For each classifier, the number of columns should be equal to the number of groups of true labels. The order of columns won't affect results.

Specificity, Sensitivity, AUC for each group and each method will be calculated. Macro/Micro-average AUC for all groups and each method will be calculated.

Micro-average ROC/AUC was calculated by stacking all groups together, thus converting the multi-class classification into binary classification. Macro-average ROC/AUC was calculated by averaging all groups results (one vs rest) and linear interpolation was used between points of ROC.

AUC will be calculated using function \code{cal_auc()}.
}
\value{
\item{Specificity}{A list of specificities for each group, each method and micro-/macro- average}
\item{Sensitivity}{A list of sensitivities for each group, each method and micro-/macro- average}
\item{AUC}{A list of AUCs for each group, each method and micro-/macro- average}
\item{Methods}{A vector contains the name of different classifiers}
\item{Groups}{A vector contains the name of different groups}
}
\references{
\href{http://scikit-learn.org/stable/auto_examples/model_selection/plot_roc.html}{http://scikit-learn.org/stable/auto_examples/model_selection/plot_roc.html}
}

\examples{
data(test_data)
roc_test <- multi_roc(test_data)
roc_test$AUC %>% unlist
}

\keyword{multi_roc}
