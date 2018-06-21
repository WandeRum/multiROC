# multiROC
Calculating and Visualizing ROC and PR Curves Across Multi-Class Classifications

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![](https://www.r-pkg.org/badges/version/multiROC)](https://www.r-pkg.org/pkg/multiROC)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/multiROC)](https://www.r-pkg.org/pkg/multiROC)
[![GitHub watchers](https://img.shields.io/github/watchers/WandeRum/multiROC.svg?style=flat&label=Watch)](https://github.com/elise-is/multiROC/watchers)
[![GitHub stars](https://img.shields.io/github/stars/WandeRum/multiROC.svg?style=flat&label=Star)](https://github.com/elise-is/multiROC/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/WandeRum/multiROC.svg?style=flat&label=Fork)](https://github.com/elise-is/multiROC/fork)

The receiver operating characteristic (ROC) and precision recall (PR) is an extensively utilized method for comparing binary classifiers in various areas. However, many real-world problems are designed to multiple classes (e.g., tumor, node, and metastasis staging system of cancer), which require an evaluation strategy to assess multiclass classifiers. This package aims to fill the gap by enabling the calculation of multiclass ROC-AUC and PR-AUC with confidence intervals and the generation of publication-quality figures of multiclass ROC curves and PR curves.

## 1 Citation
Please cite our paper once it is published: (Submitted).

## 2 Installation

Install `multiROC` from GitHub:
```r
install.packages('devtools')
require(devtools)
install_github("WandeRum/multiROC")
require(multiROC)
```
Install `multiROC`
from CRAN:
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

    ##   G1_true G2_true G3_true G1_pred_m1 G2_pred_m1 G3_pred_m1 G1_pred_m2 G2_pred_m2 G3_pred_m2
    ## 1       1       0       0  0.8566867  0.1169520 0.02636133  0.4371601  0.1443851 0.41845482
    ## 2       1       0       0  0.8011788  0.1505448 0.04827643  0.3075236  0.5930025 0.09947397
    ## 3       1       0       0  0.8473608  0.1229815 0.02965766  0.3046363  0.4101367 0.28522698
    ## 4       1       0       0  0.8157730  0.1422322 0.04199482  0.2378494  0.5566147 0.20553591
    ## 5       1       0       0  0.8069553  0.1472971 0.04574766  0.4067347  0.2355822 0.35768312
    ## 6       1       0       0  0.6894488  0.2033285 0.10722271  0.1063048  0.4800507 0.41364450

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

    ##     m1.G1     m1.G2     m1.G3  m1.macro  m1.micro     m2.G1     m2.G2     m2.G3  m2.macro  m2.micro
    ## 0.7233607 0.5276190 0.9751462 0.7420609 0.8824221 0.3237705 0.3723810 0.4020468 0.3665670 0.4174394

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

    ## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
    ## Based on 100 bootstrap replicates
    ## 
    ## CALL : 
    ## boot.ci(boot.out = res_boot, conf = conf, type = type, index = index)
    ## 
    ## Intervals : 
    ## Level       BCa          
    ## 95%   ( 0.649,  0.861 )  
    ## Calculations and Intervals on Original Scale
    ## Some BCa intervals may be unstable


    ## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
    ## Based on 100 bootstrap replicates
    ## 
    ## CALL : 
    ## boot.ci(boot.out = res_boot, conf = conf, type = type, index = index)
    ## 
    ## Intervals : 
    ## Level       BCa          
    ## 95%   ( 0.4242,  0.6547 )  
    ## Calculations and Intervals on Original Scale
    ## Warning : BCa Intervals used Extreme Quantiles
    ## Some BCa intervals may be unstable

The function **roc_ci** and **pr_ci** are used to calculate confidence intervals of multiclass ROC-AUC and PR-AUC.

Arguments of **roc_ci** and **pr_ci**:

* **data** is the dataset contains both of true labels and corresponding predicted scores. True labels (0 - Negative, 1 - Positive) columns should be named as XX_true (e.g., S1_true, S2_true) and predictive scores (continuous) columns should be named as XX_pred_YY (e.g., S1_pred_SVM, S2_pred_RF). Predictive scores can be probabilities among [0, 1] or other continuous values. For each classifier, the number of columns should be equal to the number of groups of true labels.

* **conf** contains the required level of confidence intervals, and the default number is 0.95.

* **type** includes five different types of equi-tailed two-sided nonparametric confidence intervals (e.g., "norm","basic", "stud", "perc", "bca", "all").

* **R** is the number of bootstrap replicates, the default number is 100.

* **index** is the position of the list of AUC results in 3.2.1.

Here, we set index = 4 to calculate 95% CI of AUC of Macro in the classifier m1 based on 1000 bootstrap replicates as an example.

#### 4.2.3 Output All Results

```{r, message=FALSE, warning=FALSE}
roc_auc_with_ci_res <- roc_auc_with_ci(test_data, conf= 0.95, type='bca', R = 100)
roc_auc_with_ci_res
pr_auc_with_ci_res <- pr_auc_with_ci(test_data, conf= 0.95, type='bca', R = 100)
pr_auc_with_ci_res
```

    ##         Var       AUC  lower CI higher CI
    ## 1     m1.G1 0.7233607 0.5555556 0.8406849
    ## 2     m1.G2 0.5276190 0.3141490 0.6991112
    ## 3     m1.G3 0.9751462 0.9156118 0.9969245
    ## 4  m1.macro 0.7420420 0.6162905 0.8469999
    ## 5  m1.micro 0.8824221 0.7942627 0.9318145
    ## 6     m2.G1 0.3237705 0.2039669 0.4888149
    ## 7     m2.G2 0.3723810 0.2322795 0.5126755
    ## 8     m2.G3 0.4020468 0.2266853 0.5944778
    ## 9  m2.macro 0.3665214 0.2796633 0.4970809
    ## 10 m2.micro 0.4174394 0.3449170 0.5036827


    ##         Var        AUC   lower CI higher CI
    ## 1     m1.G1 0.81104090 0.69394085 0.9219133
    ## 2     m1.G2 0.18898097 0.09755974 0.3404294
    ## 3     m1.G3 0.67479141 0.34789377 0.9871966
    ## 4  m1.macro 0.54968868 0.43208030 0.6663112
    ## 5  m1.micro 0.75125213 0.61651803 0.8635095
    ## 6     m2.G1 0.60633468 0.49548427 0.7510816
    ## 7     m2.G2 0.13298786 0.06840618 0.2092138
    ## 8     m2.G3 0.08150105 0.03931745 0.1388464
    ## 9  m2.macro 0.27320882 0.23863708 0.3009619
    ## 10 m2.micro 0.27540471 0.23380391 0.3087388

The function **roc_auc_with_ci** and **pr_auc_with_ci** are used to calculate confidence intervals of multiclass ROC-AUC, PR-AUC, and output a dataframe with AUCs, lower CIs, and higher CIs of all methods and groups.

Arguments of **roc_auc_with_ci** and **pr_auc_with_ci**:

* **data** is the dataset contains both of true labels and corresponding predicted scores. True labels (0 - Negative, 1 - Positive) columns should be named as XX_true (e.g., S1_true, S2_true) and predictive scores (continuous) columns should be named as XX_pred_YY (e.g., S1_pred_SVM, S2_pred_RF). Predictive scores can be probabilities among [0, 1] or other continuous values. For each classifier, the number of columns should be equal to the number of groups of true labels.

* **conf** contains the required level of confidence intervals, and the default number is 0.95.

* **type** includes five different types of equi-tailed two-sided nonparametric confidence intervals (e.g., "norm","basic", "stud", "perc", "bca").

* **R** is the number of bootstrap replicates, the default number is 100.

## 5 Plots

### 5.1 change the format of AUC results to a ggplot2 friendly format.
```{r}
plot_roc_df <- plot_roc_data(roc_res)
plot_pr_df <- plot_pr_data(pr_res)
```

### 5.2 Plot

### 5.2.1 ROC Plot

``` r
ggplot(plot_roc_df, aes(x = 1-Specificity, y=Sensitivity)) + geom_path(aes(color = Group, linetype=Method)) + geom_segment(aes(x = 0, y = 0, xend = 1, yend = 1), colour='grey', linetype = 'dotdash') + theme_bw() + theme(plot.title = element_text(hjust = 0.5), legend.justification=c(1, 0), legend.position=c(.95, .05), legend.title=element_blank(), legend.background = element_rect(fill=NULL, size=0.5, linetype="solid", colour ="black"))
```

#### 5.2.2 PR Plot

``` r
ggplot(plot_pr_df, aes(x=Recall, y=Precision)) + geom_path(aes(color = Group, linetype=Method), size=1.5) + theme_bw() + theme(plot.title = element_text(hjust = 0.5), legend.justification=c(1, 0), legend.position=c(.95, .05), legend.title=element_blank(), legend.background = element_rect(fill=NULL, size=0.5, linetype="solid", colour ="black"))
```

## 6 Bug Reports
For sending comments, suggestions, bug reports of multiROC, please email to Runmin Wei (wander1021@gmail.com) or report it via thus URL: https://github.com/WandeRum/multiROC/issues

## 7 License
GPL-3
