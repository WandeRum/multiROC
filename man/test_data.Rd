\name{test_data}
\alias{test_data}
\docType{data}
\title{
Example dataset
}
\description{
This example dataset contains two classifiers (m1, m2), and three groups (G1, G2, G3).
}
\usage{data("test_data")}
\format{
  A data frame with 85 observations on the following 9 variables.
  \describe{
    \item{\code{G1_true}}{true labels of G1 (0 - Negative, 1 - Positive)}
    \item{\code{G2_true}}{true labels of G2 (0 - Negative, 1 - Positive)}
    \item{\code{G3_true}}{true labels of G3 (0 - Negative, 1 - Positive)}
    \item{\code{G1_pred_m1}}{predictive scores of G1 in the classifier m1}
    \item{\code{G2_pred_m1}}{predictive scores of G2 in the classifier m1}
    \item{\code{G3_pred_m1}}{predictive scores of G3 in the classifier m1}
    \item{\code{G1_pred_m2}}{predictive scores of G1 in the classifier m2}
    \item{\code{G2_pred_m2}}{predictive scores of G2 in the classifier m2}
    \item{\code{G3_pred_m2}}{predictive scores of G3 in the classifier m2}
  }
}

\examples{
data(test_data)
}
\keyword{datasets}
