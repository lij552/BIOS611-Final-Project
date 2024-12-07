suppressMessages(library(tidyverse))
library(gridExtra)

data<-read.csv("derived_data/data.csv")

fit1<-lm(Rating~CocoaPercent_num+BroadBeanOrigin_cate+CompanyLocation_cate+ReviewDate_day,data = data)
step_fit <- step(fit1, direction = "both")

step_summary <- summary(step_fit)
coefficients_df <- as.data.frame(step_summary$coefficients)
coefficients_df <- data.frame(Variable = rownames(coefficients_df),
                              lapply(coefficients_df, function(x) if(is.numeric(x)) round(x, 5) else x))
colnames(coefficients_df) <- c("Variable", "Estimate", "Std. Error", "t value", "Pr(>|t|)")
table_grob <- tableGrob(coefficients_df)
ggsave("figures/lm.png", table_grob)


