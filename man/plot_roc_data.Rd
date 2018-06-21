\name{plot_roc_data}
\alias{plot_roc_data}
\title{
Generate ROC plotting data
}
\description{
This function generates plotting ROC data for following data visualization.
}
\usage{
plot_roc_data(roc_res)
}
\arguments{
  \item{roc_res}{A list of results from multi_roc function.}
}

\value{
  \item{roc_res_df}{The dataframe of results from multi_roc function, which is easy be visualized by ggplot2.}
}
\examples{
data(test_data)
roc_res <- multi_roc(test_data)
roc_res_df <- plot_roc_data(roc_res)
}

\keyword{plot_roc_data}
