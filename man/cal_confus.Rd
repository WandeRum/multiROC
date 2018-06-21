\name{cal_confus}
\alias{cal_confus}
\title{Calculate confusion matrices}
\description{
This function calculates the confusion matrices across different cutoff points.
}
\usage{
cal_confus(true_vec, pred_vec, force_diag=TRUE)
}
\arguments{
\item{true_vec}{A binary vector of real labels}
\item{pred_vec}{A continuous predicted score(probabilities) vector, must be the same length with \code{true_vec}}
\item{force_diag}{If TRUE, TPR and FPR will be forced to across (0, 0) and (1, 1)}
}

\details{
%%  ~~ If necessary, more details than the description above ~~
This function calculates the TP, FP, FN, TN, TPR, FPR and PPV across different cutoff points of \code{pred_vec}. TPR and FPR are forced to across (0, 0) and (1, 1) if  \code{force_diag=TRUE}.
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
\item{TP}{True positive}
\item{FP}{False positive}
\item{FN}{False negative}
\item{TN}{True negative}
\item{TPR}{True positive rate}
\item{FPR}{False positive rate}
\item{PPV}{Positive predictive value}
}
\references{
\href{https://en.wikipedia.org/wiki/Confusion_matrix}{https://en.wikipedia.org/wiki/Confusion_matrix}
}
\examples{
data(test_data)
true_vec <- test_data[, 1]
pred_vec <- test_data[, 5]
confus_res <- cal_confus(true_vec, pred_vec)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{cal_confus}% use one of  RShowDoc("KEYWORDS")
