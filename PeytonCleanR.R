vinitWorkingDirectory <- "C:/Users/peyto/OneDrive/Documents/Datafest/df2018"
setwd(vinitWorkingDirectory)

packs <- c("dplyr","ggplot2","readr","magrittr","ggmap","lubridate")
lapply(packs,library,character.only = TRUE)

dfa <- readr::read_csv("./data/datafest2018.csv")

# zero-fill a time series for specific jobId
zero_fill <- function(job_id, dfa){
  
  incomplete <- dfa %>% filter(jobId == job_id) %>% arrange(date)
  
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

# link to sectors file and add sectors column to dfa df
sector_dict <- read_csv("./data/sectors.csv")
merged <- merge(dfa,sector_dict,by.x = "normTitleCategory",by.y = "industry_name", all.x = TRUE)

# make merged summary data frame
temp <- merged %>% distinct(jobId, .keep_all = TRUE)

days <- merged %>% group_by(jobId) %>% mutate(days_active = as.double(difftime(max(date),min(date),units="days"))+1) %>% select(jobId,days_active)

clicksumdf <- merged %>% group_by(jobId) %>% summarise(sum_clicks = sum(clicks),sum_localclicks = sum(localClicks))

summary_merge <- merge(temp,clicksumdf, by = "jobId")
summary_merge <- merge(summary_merge,days, by = "jobId")

clean <- summary_merge %>% select(-c(clicks,jobAgeDays,localClicks,date)) %>% distinct(jobId)

rm(clicksumdf,merged,summary_merge,temp,days,days)







######################################################################################################
##Write Clean

write.csv(clean,file='cleandata.csv')

clean$clicksperday <- clean$sum_clicks/clean$days_active
clean$localclicksperday <- clean$sum_localclicks/clean$days_active

write.csv(clean,file='cleanerdata.csv')

pop <- read_csv("./data/USPopulation.csv")
pop2 <- pop[,c(9,10,19)]
pop2$POPESTIMATE2016 <- as.numeric(pop2$POPESTIMATE2016)

USStates <- data.frame(state.abb,state.name)
colnames(USStates)=c('stateProvince','State')

pop3 <- merge(pop2,USStates,by.x='STNAME',by.y='State', all.x=T)

merged2 <- merge(clean, pop3, by.x=c('city','stateProvince'), by.y=c('NAME','stateProvince'),all.x=T)







