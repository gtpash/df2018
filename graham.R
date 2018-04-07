#setwd("C:/Users/graha/Dropbox/Graham/documents/GitHub/df2018")
# mykey <- "AIzaSyDbTwdfJGvyiPpNJ_VaLj2TvLvimcV7AUQ" #graham

packs <- c("dplyr","ggplot2","readr","magrittr","ggmap","lubridate")
lapply(packs,library,character.only = TRUE)

raw <- readr::read_csv("./data/datafest2018.csv")

company <- summarise(group_by(raw,companyId), count = n())

# save city locations in csv
city_counts <- raw %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`)) %>% slice(2:12501)

# zero-fill click data
samp <- sample_n(raw,1000)
daterange_jobId <- raw %>% group_by(jobId) %>% filter(max(jobAgeDays) > 0) %>% summarize(min(date),max(jobAgeDays))
hist(daterange_jobId$postlength)

# zero-fill a time series for specific jobId
zerofillyboi <- function(job_id, raw){
  
  incomplete <- raw %>% filter(jobId == job_id) %>% arrange(date)
  
  daterange <- incomplete %>% summarize(min(date),as.double(difftime(max(date),min(date),units="days")))
  colnames(daterange) <- c("firstdate","postlength")
  fulldates <- data.frame(date = seq(from = daterange$firstdate, by = "day", length.out = daterange$postlength+1))
  
  zerofill <- merge(fulldates,incomplete,by = "date",all.x = TRUE)
  
  update <- c("clicks","localClicks") 
  zerofill[update][is.na(zerofill[update])] <- 0
  
  invariant <- zerofill %>% select(companyId:educationRequirement) %>% colnames()
  zerofill[invariant] <- zerofill %>% slice(1) %>% select(invariant) 
  
  zerofillyboi <- zerofill
  
}

# timing test
testjobs <- sample_n(raw,10)
time1<-proc.time()
timeseriesjobs <- NULL
for(i in 1:length(testjobs)){
  timeseriesjobs <- rbind(timeseriesjobs,zerofillyboi(testjobs$jobId[i],raw))
}
print(paste0(round(((proc.time() - time1)[3])/60,digits = 3)," minutes from start"))
