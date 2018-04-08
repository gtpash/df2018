vinitWorkingDirectory <- "~/Documents/df2018"
setwd(vinitWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

fix_industry <- function(df_row) {
  
}

unique_jobs_with_industry <- datafest2018 %>% distinct(jobId, .keep_all = TRUE) %>% filter(!is.na(industry))
#by(unique_jobs, 1:nrow(unique_jobs))
new <- unique_jobs_with_industry[FALSE,]
for (i in 1:nrow(unique_jobs_with_industry)){
  row <- unique_jobs_with_industry[i,]
#  print(row[9][[1,1]])
#  print(length(strsplit(row[9][[1,1]], ',')[[1]]))
  x <- strsplit(row[9][[1,1]], ',')[[1]]
  if (length(x) > 1){
    bind_rows(new,row)
  }
}