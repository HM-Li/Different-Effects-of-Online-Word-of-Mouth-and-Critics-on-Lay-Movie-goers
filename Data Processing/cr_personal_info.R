library(data.table)
library(Hmisc)
library(dplyr)
library(VIM)
library(reshape2)
path.wd <- getwd()
path.input <- file.path(path.wd,"Input")
path.output <- file.path(path.wd,"Output")
cr.rate <- fread(file.path(path.input,"cr_rate_4_input.csv"))
attach(cr.rate)
cr.personal.count <- aggregate(Index~UID, FUN = length)
cr.personal.fresh <- aggregate(Fresh~UID, FUN = sum)
cr.rate.sub <- subset(cr.rate, cr.rate$Rate_conv != "Null"&cr.rate$Rate_conv!= "0")
describe(cr.rate.sub$Rate_conv)
cr.rate.sub$Rate_conv <- as.numeric(cr.rate.sub$Rate_conv)
detach(cr.rate)
attach(cr.rate.sub)
cr.personal.avgrate <- aggregate(Rate_conv~UID, FUN = mean)
cr.personal.startdate <- aggregate(Date~UID, FUN = min)
cr.personal.top <- data.frame(unique(cbind(cr.rate$UID,cr.rate$Top)))
cr.personal.top <- as.data.table(cr.personal.top)
cr.personal.top <- data.frame(unique(cr.personal.top,by = "UID", fromLast = T))
describe(cr.personal.top)
cr.personal <- full_join(cr.personal.avgrate,cr.personal.count,by = "UID")
cr.personal <- full_join(cr.personal,cr.personal.fresh,by = "UID")
cr.personal <- full_join(cr.personal,cr.personal.startdate,by = "UID")
cr.personal <- full_join(cr.personal,cr.personal.top,by = "UID")
describe(cr.personal)
fix(cr.personal)
write.csv(cr.personal, file.path(path.output,"critics_info.csv"),row.names = F)
