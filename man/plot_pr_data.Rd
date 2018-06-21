\name{plot_pr_data}
\alias{plot_pr_data}
\title{
Generate PR plotting data
}
\description{
This function generates plotting PR data for following data visualization.
}
\usage{
plot_pr_data(pr_res)
}
\arguments{
  \item{pr_res}{A list of results from multi_pr function.}
}

\value{
  \item{pr_res_df}{The dataframe of results from multi_pr function, which is easy be visualized by ggplot2.}
}
\examples{
data(test_data)
pr_res <- multi_pr(test_data)
pr_res_df <- plot_pr_data(pr_res)
}

\keyword{plot_pr_data}
