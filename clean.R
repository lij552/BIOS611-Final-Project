suppressMessages(library(tidyverse))
data<-read.csv("./flavors_of_cacao.csv")
names(data) <- c(
  "Company",
  "BeanOrigin",
  "Ref",
  "ReviewDate",
  "CocoaPercent",
  "CompanyLocation",
  "Rating",
  "BeanType",
  "BroadBeanOrigin"
)
data[data == ""] <- NA

#Bean Origin
origin_freq <- sort(table(data$BroadBeanOrigin, useNA = "no"), decreasing = TRUE)

top_origins <- names(origin_freq[1:5])

data$BroadBeanOrigin_cate <- ifelse(data$BroadBeanOrigin %in% top_origins,
                               data$BroadBeanOrigin,
                               "Other")

#Company location
origin_freq <- sort(table(data$CompanyLocation, useNA = "no"), decreasing = TRUE)

top_origins <- names(origin_freq[1:10])

data$CompanyLocation_cate <- ifelse(data$CompanyLocation %in% top_origins,
                                    data$CompanyLocation,
                                    "Other")

#CocoaPercent
data$CocoaPercent_num <- as.numeric(sub("%", "", data$CocoaPercent))/100

data <- data %>%
  rename(
    ReviewDate_day = Ref
  )


write.csv(data,"derived_data/data.csv")