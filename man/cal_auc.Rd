\name{cal_auc}
\alias{cal_auc}
\title{Area under ROC curve}
\description{This function calculates the area under ROC curve}
\usage{cal_auc(X, Y)}
\arguments{
\item{X}{A vector of true positive rate}
\item{Y}{A vector of false positive rate, same length with TPR}
}
\details{
This function calculates the area under ROC curve.
}
\value{
A numeric value of AUC will be returned.
}
\references{
\href{https://www.r-bloggers.com/calculating-auc-the-area-under-a-roc-curve/}{https://www.r-bloggers.com/calculating-auc-the-area-under-a-roc-curve/}
}

\seealso{
\code{\link[=cal_confus]{cal_confus()}}
}

\examples{
data(test_data)
true_vec <- test_data[, 1]
pred_vec <- test_data[, 5]
confus_res <- cal_confus(true_vec, pred_vec)
AUC_res <- cal_auc(confus_res$TPR, confus_res$FPR)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{cal_auc}% use one of  RShowDoc("KEYWORDS")
