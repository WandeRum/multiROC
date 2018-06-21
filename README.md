# multiROC
Calculating and Visualizing ROC and PR Curves Across Multi-Class Classifications

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![](https://www.r-pkg.org/badges/version/multiROC)](https://www.r-pkg.org/pkg/multiROC)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/multiROC)](https://www.r-pkg.org/pkg/multiROC)
[![GitHub watchers](https://img.shields.io/github/watchers/WandeRum/multiROC.svg?style=flat&label=Watch)](https://github.com/elise-is/multiROC/watchers)
[![GitHub stars](https://img.shields.io/github/stars/WandeRum/multiROC.svg?style=flat&label=Star)](https://github.com/elise-is/multiROC/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/WandeRum/multiROC.svg?style=flat&label=Fork)](https://github.com/elise-is/multiROC/fork)

This package aims to fill the gap by enabling the calculation of multiclass ROC-AUC and multiclass PR-AUC with confidence intervals and the generation of publication-quality figures.

## 1 Citation
Please cite our paper once it is published: (Submitted).

## 2 Installation

You can install `multiROC` from GitHub:
```r
install.packages('devtools')
require(devtools)
install_github("WandeRum/multiROC")
require(multiROC)
```
or from CRAN:
```r
install.packages('multiROC')
require(multiROC)
```
## 3 Data preparation
```r
library(multiROC)
data(test_data)
head(test_data)
```
This example dataset contains two classifiers (m1, m2), and three groups (G1, G2, G3).

## 4 MultiROC in a nutshell

### 4.1 multi_roc and multi_pr function
```{r}
roc_res <- multi_roc(test_data, force_diag=T)
pr_res <- multi_pr(test_data, force_diag=T)
```
The function **multi_roc** and **multi_pr** are core functions for calculating multiclass ROC-AUC and PR-AUC.

Arguments of **multi_roc** and **multi_pr**:

* **data** is the dataset contains both of true labels and corresponding predicted scores. True labels (0 - Negative, 1 - Positive) columns should be named as XX_true (e.g., S1_true, S2_true) and predictive scores (continuous) columns should be named as XX_pred_YY (e.g., S1_pred_SVM, S2_pred_RF). Predictive scores can be probabilities among [0, 1] or other continuous values. For each classifier, the number of columns should be equal to the number of groups of true labels.

* If **force_diag** equals TRUE, true positive rate (TPR) and false positive rate (FPR) will be forced to across (0, 0) and (1, 1).

Outputs of **multi_roc**:

* **Specificity** contains a list of specificities for each group of different classifiers. 

* **Sensitivity** contains a list of sensitivities for each group of different classifiers. 

* **AUC** contains a list of AUC for each group of different classifiers. Micro-average ROC-AUC was calculated by stacking all groups together, thus converting the multi-class classification into binary classification. Macro-average ROC-AUC was calculated by averaging all groups results (one vs rest) and linear interpolation was used between points of ROC.

* **Methods** shows names of different classifiers. 

* **Groups** shows names of different groups.  

Outputs of **multi_pr**:

* **Recall** contains a list of recalls for each group of different classifiers. 

* **Precision** contains a list of precisions for each group of different classifiers. 

* **AUC** contains a list of AUC for each group of different classifiers. Micro-average PR-AUC was calculated by stacking all groups together, thus converting the multi-class classification into binary classification. Macro-average PR-AUC was calculated by averaging all groups results (one vs rest) and linear interpolation was used between points of ROC.

* **Methods** shows names of different classifiers. 

* **Groups** shows names of different groups.  

### 4.2 Confidence Intervals

#### 4.2.1 List of AUC results

```{r}
unlist(roc_res$AUC)
```

This list shows the following AUC information: 

1) AUC of G1 v.s. the rest in the classifier m1; 
2) AUC of G2 v.s. the rest in the classifier m1; 
3) AUC of G3 v.s. the rest in the classifier m1; 
4) AUC of Macro in the classifier m1; 
5) AUC of Micro in the classifier m1; 
6) AUC of G1 v.s. the rest in the classifier m2; 
7) AUC of G2 v.s. the rest in the classifier m2; 
8) AUC of G3 v.s. the rest in the classifier m2; 
9) AUC of Macro in the classifier m2; 
10) AUC of Micro in the classifier m2.

#### 4.2.2 Bootstrap

```{r}
roc_ci_res <- roc_ci(test_data, conf= 0.95, type='basic', R = 100, index = 4)
pr_ci_res <- pr_ci(test_data, conf= 0.95, type='basic', R = 100, index = 4)
```

The function **roc_ci** and **pr_ci** are used to calculate confidence intervals of multiclass ROC-AUC and PR-AUC.

Arguments of **roc_ci** and **pr_ci**:

* **data** is the dataset contains both of true labels and corresponding predicted scores. True labels (0 - Negative, 1 - Positive) columns should be named as XX_true (e.g., S1_true, S2_true) and predictive scores (continuous) columns should be named as XX_pred_YY (e.g., S1_pred_SVM, S2_pred_RF). Predictive scores can be probabilities among [0, 1] or other continuous values. For each classifier, the number of columns should be equal to the number of groups of true labels.

* **conf** contains the required level of confidence intervals, and the default number is 0.95.

* **type** includes five different types of equi-tailed two-sided nonparametric confidence intervals (e.g., "norm","basic", "stud", "perc", "bca", "all").

* **R** is the number of bootstrap replicates, the default number is 100.

* **index** is the position of the list of AUC results in 3.2.1.

Here, we set index = 4 to calculate 95% CI of AUC of Macro in the classifier m1 based on 1000 bootstrap replicates as an example.

## 5 Plots

### 5.1 change the format of AUC results to a ggplot2 friendly format.
```{r}
plot_roc_df <- plot_roc_data(roc_res)
plot_pr_df <- plot_pr_data(pr_res)
```

### 5.2 Plot
```{r, fig.width=7, fig.height=5.5}
ggplot2::ggplot(plot_roc_df, ggplot2::aes(x = 1-Specificity, y=Sensitivity)) + 
  ggplot2::geom_path(ggplot2::aes(color = Group, linetype=Method)) + 
  ggplot2::geom_segment(ggplot2::aes(x = 0, y = 0, xend = 1, yend = 1), 
                        colour='grey', linetype = 'dotdash') + 
  ggplot2::theme_bw() + 
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5), 
                 legend.justification=c(1, 0), legend.position=c(.95, .05), 
                 legend.title=ggplot2::element_blank(), 
                 legend.background = ggplot2::element_rect(fill=NULL, size=0.5, 
                                                           linetype="solid", colour ="black"))
```

## 6 Bug Reports
For sending comments, suggestions, bug reports of multiROC, please email to Runmin Wei (RWei AT cc DOT hawaii DOT edu) or report it via thus URL: https://github.com/elise-is/multiROC/issues

## 7 License
GPL-3
