\name{roc_auc_with_ci}
\alias{roc_auc_with_ci}
\title{Output of ROC bootstrap confidence intervals}
\description{
This function uses bootstrap to generate five types of equi-tailed two-sided confidence intervals of ROC-AUC with different required percentages and output a dataframe with AUCs, lower CIs, and higher CIs of all methods and groups.
}
\usage{
roc_auc_with_ci(data, conf= 0.95, type='bca', R = 100)
}
\arguments{
\item{data}{A data frame contains true labels of multiple groups and corresponding predictive scores.}
\item{conf}{A scalar contains the required level of confidence intervals, and the default number is 0.95.}
\item{type}{A vector of character strings includes five different types of equi-tailed two-sided nonparametric confidence intervals (e.g., "norm","basic", "stud", "perc", "bca").}
\item{R}{A scalar contains the number of bootstrap replicates, and the default number is 100.}
}
\details{
A data frame is required for this function as input. This data frame should contains true label (0 - Negative, 1 - Positive) columns named as XX_true (e.g. S1_true, S2_true and S3_true) and predictive scores (continuous) columns named as XX_pred_YY (e.g. S1_pred_SVM, S2_pred_RF).
Predictive scores could be probabilities among [0, 1] and other continuous values.
For each classifier, the number of columns should be equal to the number of groups of true labels. The order of columns won't affect results.
}
\value{
\item{norm}{Using the normal approximation to calculate the confidence intervals.}
\item{basic}{Using the basic bootstrap method to calculate the confidence intervals.}
\item{stud}{Using the studentized bootstrap method to calculate the confidence intervals.}
\item{perc}{Using the bootstrap percentile method to calculate the confidence intervals.}
\item{bca}{Using the adjusted bootstrap percentile method to calculate the confidence intervals.}
}
\examples{
data(test_data)
roc_auc_with_ci_res <- roc_auc_with_ci(test_data, conf= 0.95, type='bca', R = 100)
}
\keyword{roc_auc_with_ci_res}