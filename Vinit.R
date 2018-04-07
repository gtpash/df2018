vinitWorkingDirectory <- "~/Documents/df2018"
setwd(vinitWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr")
lapply(Packages, library, character.only = TRUE)

data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

datafest2018 %>% group_by(companyId) %>% summarize(n()) -> companies
datafest2018 %>% filter(companyId == "company00090") %>% mean(.$estimatedSalary)
city_counts <- datafest2018 %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`)) %>% slice(2:12501)
