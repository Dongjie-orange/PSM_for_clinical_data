library(ggplot2)
library(survival)
library(data.table)
library(tidyverse)
library(survminer)

dat <- readxl::read_xlsx('Data/工作簿9.xlsx',1) %>% 
  drop_na('OS') %>% 
  rename('OS.status' = '生存情况（生存0，死亡1）',
         'PSR' = '手术分类(PSR1)') %>% 
  mutate_at(grep('OS.status',colnames(dat)),as.numeric) %>% 
  mutate_at(grep('PSR',colnames(dat)),as.factor)

km <- survfit(Surv(OS,OS.status)~PSR,data = dat)
summary(km)
ggsurvplot(km,
           dat,
           palette=rev(c("#E64B35E5" ,"#4DBBD5E5")),
           pval=T,
           surv.median.line = "hv" ,
           risk.table = TRUE,  
           legend.title = "",
           legend = c(0.8,0.9))



dat2 <- dat[dat$OS.status == 1,] 
