#setwd("C:/Users/graha/Dropbox/Graham/documents/GitHub/df2018/R_proj")

packs <- c("dplyr","ggplot2","readr","magrittr")
lapply(packs,library,character.only = TRUE)

dpath <- "../data/"
raw <- readr::read_csv(paste0(dpath,"datafest2018.csv"))
