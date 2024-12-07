suppressMessages(library(tidyverse))
library(reshape2)
library(splines)

data<-read.csv("derived_data/data.csv")

#plot distribution
plt1<-ggplot(data, aes(x = Rating)) +
  geom_histogram(binwidth = 0.1, color = "black", fill = "blue", alpha = 0.7) +
  labs(
    title = "Distribution of Ratings",
    x = "Rating",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave("figures/dist_rate.png",plot=plt1)

plt2<-ggplot(data, aes(x = CocoaPercent_num)) +
  geom_histogram(binwidth = 0.01, color = "black", fill = "blue", alpha = 0.7) +
  scale_x_continuous(
    breaks = seq(floor(min(data$CocoaPercent_num, na.rm = TRUE)), 
                 ceiling(max(data$CocoaPercent_num, na.rm = TRUE)), 
                 by = 0.05)
  ) +
  labs(
    title = "Distribution of Cocoa Percents",
    x = "Cocoa Percent",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave("figures/dist_cocoa.png",plot=plt2)

data <- data %>%
  mutate(BroadBeanOrigin_cate = fct_reorder(BroadBeanOrigin_cate, 
                                            -prop.table(table(BroadBeanOrigin_cate))[BroadBeanOrigin_cate]))

plt3<-ggplot(data, aes(x = "", fill = BroadBeanOrigin_cate)) +
  geom_bar(aes(y = ..count../sum(..count..)), width = 1, stat = "count") +
  coord_polar(theta = "y") +
  labs(
    title = "Top 5 Broad Bean Origin Countries",
    x = NULL,
    y = NULL,
    fill = "Broad Bean Origin"
  ) +
  theme_minimal() +
  theme(axis.ticks = element_blank(), axis.text = element_blank())

ggsave("figures/pie_broad.png",plot=plt3)

data <- data %>%
  mutate(CompanyLocation_cate = fct_reorder(CompanyLocation_cate, 
                                            -prop.table(table(CompanyLocation_cate))[CompanyLocation_cate]))

plt4<-ggplot(data, aes(x = "", fill = CompanyLocation_cate)) +
  geom_bar(aes(y = ..count../sum(..count..)), width = 1, stat = "count") +
  coord_polar(theta = "y") +
  labs(
    title = "Top 10 Company Origin Countries",
    x = NULL,
    y = NULL,
    fill = "Company Origin"
  ) +
  theme_minimal() +
  theme(axis.ticks = element_blank(), axis.text = element_blank())

ggsave("figures/pie_company.png",plot=plt4)

plt5<-ggplot(data, aes(x = ReviewDate)) +
  geom_histogram(binwidth = 1, color = "black", fill = "blue", alpha = 0.7) +
  scale_x_continuous(breaks = seq(floor(min(data$ReviewDate)), ceiling(max(data$ReviewDate)), by = 1)) +
  labs(
    title = "Distribution of Review year",
    x = "Review year",
    y = "Frequency"
  ) +
  theme_minimal()

ggsave("figures/dist_review.png",plot=plt5)

# Convert categorical variables to numeric (e.g., using their factor levels)
data$BroadBeanOrigin_cate <- as.numeric(as.factor(data$BroadBeanOrigin_cate))
data$CompanyLocation_cate <- as.numeric(as.factor(data$CompanyLocation_cate))

# Select the relevant columns
selected_data <- data[, c("Rating", "CocoaPercent_num", "BroadBeanOrigin_cate", 
                          "CompanyLocation_cate", "ReviewDate_day")]

# Compute the correlation matrix
cor_matrix <- cor(selected_data, use = "pairwise.complete.obs")

# Melt the correlation matrix for ggplot
cor_melt <- melt(cor_matrix)

# Create a ggplot heatmap of the correlation matrix
plt6<-ggplot(cor_melt, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = "", y = "", title = "Correlation Matrix Heatmap")

ggsave("figures/corr.png",plot=plt6)

plt7<-ggplot(data, aes(x = CocoaPercent_num, y = Rating)) +
  geom_point(alpha = 0.6) +  # Scatter points with some transparency
  geom_smooth(method = "lm", formula = y ~ ns(x, df = 3), color = "blue", se = TRUE) +
  scale_x_continuous(
    breaks = seq(floor(min(data$CocoaPercent_num, na.rm = TRUE)), 
                 ceiling(max(data$CocoaPercent_num, na.rm = TRUE)), 
                 by = 0.05)
  ) +
  labs(
    title = "Scatterplot of Cocoa Percent vs Rating with Natural Spline Fit",
    x = "Cocoa Percent",
    y = "Rating"
  ) +
  theme_minimal()

ggsave("figures/corr_CR.png",plot=plt6)

