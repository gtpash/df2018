
vinitWorkingDirectory <- "~/Documents/df2018"
setwd(vinitWorkingDirectory)

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
zero_fill <- function(job_id, raw){
  
  incomplete <- raw %>% filter(jobId == job_id) %>% arrange(date)
  
  daterange <- incomplete %>% summarize(min(date),as.double(difftime(max(date),min(date),units="days")))
  colnames(daterange) <- c("firstdate","postlength")
  fulldates <- data.frame(date = seq(from = daterange$firstdate, by = "day", length.out = daterange$postlength+1))
  
  zerofill <- merge(fulldates,incomplete,by = "date",all.x = TRUE)
  
  update <- c("clicks","localClicks") 
  zerofill[update][is.na(zerofill[update])] <- 0
  
  invariant <- zerofill %>% select(companyId:educationRequirement) %>% colnames()
  zerofill[invariant] <- zerofill %>% slice(1) %>% select(invariant) 
  
  zero_fill <- zerofill
  
}

# link to sectors file and add sectors column to raw df
sector_dict <- read_csv("./data/sectors.csv")
merged <- merge(raw,sector_dict,by.x = "normTitleCategory",by.y = "industry_name", all.x = TRUE)

# make merged summary data frame
temp <- merged %>% distinct(jobId, .keep_all = TRUE)

days <- merged %>% group_by(jobId) %>% mutate(days_active = as.double(difftime(max(date),min(date),units="days"))+1) %>% select(jobId,days_active)

clicksumdf <- merged %>% group_by(jobId) %>% summarise(sum_clicks = sum(clicks),sum_localclicks = sum(localClicks))


summary_merge <- merge(temp,clicksumdf, by = "jobId")
summary_merge <- merge(summary_merge,days, by = "jobId")

clean <- summary_merge %>% select(-c(clicks,jobAgeDays,localClicks,date)) %>% distinct(jobId, .keep_all = TRUE)

#rm(raw,clicksumdf,merged,summary_merge,temp)

uspop <- read_csv("./data/USPopulation.csv")
uspop <- uspop %>% select(c("NAME","STNAME","POPESTIMATE2016"))
library(gsubfn)
newpop <- gsubfn(paste(names(uspop),collapse='|'), uspop,uspop$NAME)
newpop <- tolower(newpop)
uspop <- cbind(uspop[,-1],newpop)

USStates <- data.frame(state.abb,state.name)
colnames(USStates)=c('stateProvince','State')
USStates$State <- as.character(USStates$State)

cleanUS <- clean %>% filter(country == "US")
cleanUS$city <- tolower(cleanUS$city)

merged_uspop <- merge(uspop,USStates,by.x = "STNAME",by.y = "State")

colnames(merged_uspop)[3] <- "city"


merged_clean_samp <- merge(clean_samp,merged_uspop,by="city",all.x=T)

bysector <- ddply(clean, c("sector","isrural"), summarise,
                  mean_clicks_total = mean(totalclicks),
                  sd_clicks_total = sd(totalclicks),
                  mean_clicks_local = mean(localclicks),
                  sd_clicks_local = sd(localclicks)
)














