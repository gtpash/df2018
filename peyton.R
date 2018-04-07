##DATAFEST
##April 6-8, 2018
##Peyton Wood, Jason Thompson, Graham Pash, Vinett, Sam


##Set WD
setwd("C:/Users/peyto/OneDrive/Documents/Datafest/df2018")
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

##Read in data
data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

numjobID<- datafest2018 %>% group_by(jobId) %>% summarize(n())


#subset to work on in Tableu
subsetdf18<- datafest2018[1:10000,]
write.csv(subsetdf18,file='subsetdf18.csv')


##Generate Lat Logn Data
allcity_counts <- datafest2018 %>% 
  group_by(city) %>% select(city,stateProvince,country) 

##Make DF with all city state country
city.state.country <- allcity_counts %>% group_by(city,stateProvince,country) %>% summarise(ncity=n())

##Make US DF
cscUSA <- city.state.country %>% filter(country=="US")
write.csv(cscUSA, file='./data/USAcity.csv')

##Make Canada DF
cscCA <- city.state.country %>% filter(country=="CA")
write.csv(cscCA, file='./data/CAcity.csv')

##Make German DF
cscDE <- city.state.country %>% filter(country=="DE")
write.csv(cscDE, file='./data/DEcity.csv')


##Combine LatLong Data
USLL <- read_csv('./data/USALatLong.csv')
CALL <- read_csv('./data/CALatLong.csv')
DELL <- read_csv('./data/DELatLong.csv')

ALLLatLong <- rbind(USLL,CALL,DELL)
colnames(ALLLatLong) <- c('city','Country','stateProvince','Latitude','Longitude')

write.csv(ALLLatLong,file='./data/AllLatLong')

##Bind all Lat Long Data to original dataset
datafest2 <- datafest2018
datafestLL <- merge(datafest2,ALLLatLong, by=c('city','stateProvince'))
write.csv(datafestLL,file='datafestll.csv')


datafestLL2 <- datafestLL %>% filter(is.na(Latitude)==FALSE)
write.csv(datafestLL2,file='datafestll2.csv')


##Count of Data per country
countrycount <- datafest2018 %>% group_by(country) %>% summarise(CountryCount=n())

##Salary Exploration
SalaryMeanbyCategory <- datafest2018 %>% 
  group_by(normTitleCategory) %>% 
  summarise(meanSal=mean(estimatedSalary)) %>% 
  arrange(desc(meanSal))

##Company's Average Rating
AverageRatingbyCompany <- datafest2018 %>% group_by(companyId) %>% 
  summarise(meanrating=mean(avgOverallRating),Count=n()) %>% arrange(desc(meanrating),desc(Count))


##Arrange by Salary
datafestSALorder <- datafestLL %>% arrange(desc(estimatedSalary))



##get unique regions
UniqueRegion <- datafest2018 %>% group_by(country, stateProvince) %>% summarise(count=n()) %>% arrange(count)

#### Scrape US population data, also look for Canada and Germany
require('rvest')
website = read_html("https://simple.wikipedia.org/wiki/List_of_U.S._states_by_population")

USdata = website %>%
  #We get our nodes from using Selector Gadget, a browser plug in.
  html_nodes("td") %>%
  html_text()

#Converts vector into matrix
USdata =matrix(USdata, ncol=9, byrow=T)

#Converts matrix into data frame
USdata = as.data.frame(USdata, stringsAsFactors = F)
USdata <- USdata[,3:5]
#Adds name to the columns in data frame.
colnames(USdata) = c("State","Population2017","Population2010")
USdata <- USdata %>% arrange(State)
USdata <- USdata[1:60,]

#trim data
require('stringr')
USdata$State=str_trim(USdata$State)

USStates <- data.frame(state.abb,state.name)
colnames(USStates)=c('stateProvince','State')

USStates$State <- as.character(USStates$State)
USdata2 <- merge(USdata,USStates, by='State',all.x=T)

##Add in US territories
USdata2$StateInt <- as.character(USdata2$StateInt)
USdata2$StateInt[c(3,10,13,19,27,40,44,46,52,56)] <- c('AS','DC','GU','UM','UM','MP','UM','PR','VI','UM')

UniqueRegion <- merge(UniqueRegion,USdata2[,c(2,4)], by='stateProvince',all.x=T)


##Now CANADA
website = read_html("http://www.statcan.gc.ca/tables-tableaux/sum-som/l01/cst01/demo02a-eng.htm")

CAdata = website %>%
  #We get our nodes from using Selector Gadget, a browser plug in.
  html_nodes(".cst-tbl-data , .cst-tbl-r1") %>%
  html_text()

#Converts vector into matrix
CAdata =matrix(CAdata, ncol=6, byrow=T)

#Converts matrix into data frame
CAdata = as.data.frame(CAdata, stringsAsFactors = F)
CAdata <- CAdata[,c(1,6)]







###########################################################################################################
#Regression on the HealthcareJobs/Capita
#Also have Mortality Rate
data <- './data/mortality_healthJobs.csv'
healthstuff <- read_csv(data)

colnames(healthstuff)[7] <- "AgeAdjustedRate"

healthmodel <- lm(AgeAdjustedRate ~ JobsToPop, healthstuff)

require(ggplot2)

g <- ggplot(healthmodel,aes(x=JobsToPop,y=AgeAdjustedRate))

g+geom_point()+geom_smooth(method= 'lm')

cor(x=healthstuff$JobsToPop,y=healthstuff$AgeAdjustedRate)


###################################################################################################################

# zero-fill click data
samp <- sample_n(raw,1000)
datafestfilled <- datafest2 %>% group_by(jobId) %>% filter(max(jobAgeDays) > 0) %>% summarize(min(date),max(jobAgeDays))
hist(datafestfilled$postlength)












