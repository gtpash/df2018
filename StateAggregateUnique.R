vinitWorkingDirectory <- "~/Documents/df2018"
setwd(vinitWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

samp <- datafest2018 %>% sample_n(1000)
unique <- samp %>% distinct(jobId, .keep_all = TRUE) %>% filter(country == 'US') %>% group_by(stateProvince) %>% summarize(ncity = n())
unique_health <- datafest2018 %>% distinct(jobId, .keep_all = TRUE) %>% filter(country == 'US', industry == 'HEALTH_CARE') %>% group_by(stateProvince) %>% summarize(ncity = n())
pre_unique_industry <- datafest2018 %>% distinct(jobId,.keep_all = TRUE) %>% group_by(industry) %>% summarize(n()) %>% arrange(`n()`)
unique_industry <- datafest2018 %>% distinct(jobId,industry,.keep_all = TRUE) %>% group_by(industry) %>% summarize(n()) %>% arrange(`n()`)

#unique <- datafest2018 %>% distinct(jobId, .keep_all = TRUE) %>% filter(country == 'US') %>% group_by(stateProvince) %>% summarize(ncity = n())
#write_csv(unique,"./data/state_aggregate.csv")
#write_csv(unique_health, "./data/state_aggregate_health.csv")
