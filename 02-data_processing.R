

  

##### Code except for MP and EN sheet -------------------------------------------------------------------------------------------------------

rm(list = ls());gc()


r <- 2
c <- 0.2

# load package
library(rio)
library(tidyverse)
library(MatchIt)
library(compareGroups)

# load data
path <- 'Data/基线和结果数据库0228-8.xlsx'
dat_ls <- import_list(path) 
dat_ls <- dat_ls[c(1:3,6)]

for (x in 1:length(dat_ls)) {
  
  # x <- 2
  
  dat <- dat_ls[[x]] 
  
  table(dat$Treatment)
  
  dat[grep('<0.5',dat$CEA),'CEA'] <- 0.5 # debug
  dat[grep('<0.8',dat$CA99),'CA99'] <- 0.8 # debug
  
  
    
    dat1 <- dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:12),as.numeric) %>%
      mutate_at(c(13:18,25:43),as.factor) 
    
    dat1$Treatment <- factor(dat1$Treatment,levels = c('PD','En'))
    # dat1$Treatment <- factor(dat1$Treatment,levels = c('PD','En'))
    
    dat2 <-  dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      # na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:12),as.numeric) %>%
      mutate_at(c(13:18,25:43),as.factor) 
    
    dat2$Treatment <- factor(dat2$Treatment,levels = c('PD','En'))
    
  # PSM 
  psm_dat <- matchit(
    data = dat1,
    formula = as.formula(paste("Treatment ~ ", paste0(colnames(dat1)[c(2,3,12,14)], collapse="+"))),
    method = "nearest",
    distance = "glm",
    replace = F,
    ratio = r,
    caliper = c)
  
  summary(psm_dat)
  
  psm_dat_match <- match.data(psm_dat) %>% 
    select(-c('distance','weights','subclass')) 
  write.csv(psm_dat_match,paste0(names(dat_ls)[x],'_psm_matched_clinical_data.csv'))
  
  
  # comparegroups - psm
  restab <- descrTable(Treatment ~ ., data = psm_dat_match,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_psm_result.csv'))
  
  # comparegroups - no_psm
  restab <- descrTable(Treatment ~ ., data = dat2,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_no_psm_result.csv'))
  
}




##### Code for MP and EN sheet -------------------------------------------------------------------------------------------------------

# rm(list = ls());gc()

# load package
library(rio)
library(tidyverse)
library(MatchIt)
library(compareGroups)

# load data
path <- 'Data/基线和结果数据库0228-8.xlsx'
dat_ls <- import_list(path) 
dat_ls <- dat_ls[4:5]

for (x in 1:length(dat_ls)) {
  
  # x <- 2
  
  dat <- dat_ls[[x]] 
  
  dat[grep('<0.5',dat$CEA),'CEA'] <- 0.5 # debug
  dat[grep('<0.8',dat$CA99),'CA99'] <- 0.8 # debug
  
  if (ncol(dat) == 45) {
    
    dat2 <- dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      # na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:13),as.numeric) %>%
      mutate_at(c(1,14:19,26:44),as.factor) 
    
  } else if (ncol(dat) == 44){
  
    dat2 <-  dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      # na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:12),as.numeric) %>%
      mutate_at(c(1,13:18,25:43),as.factor) 
    
  }
  
  # comparegroups - no_psm
  restab <- descrTable(treatment ~ ., data = dat2,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_no_psm_result.csv'))
  
}



#####  EN BMI psm -------------------------------------------------------------------------------------------------------

# rm(list = ls());gc()

# load package
library(rio)
library(tidyverse)
library(MatchIt)
library(compareGroups)

# load data
path <- 'Data/基线和结果数据库0228-8.xlsx'
dat_ls <- import_list(path) 
dat_ls <- dat_ls[4:5]

r <- 1
c <- 0.2

x <- 2
dat <- dat_ls[[x]] 
  
  dat[grep('<0.5',dat$CEA),'CEA'] <- 0.5 # debug
  dat[grep('<0.8',dat$CA99),'CA99'] <- 0.8 # debug
  
    
    dat1 <- dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term',
             'distance_' = 'distance') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:13),as.numeric) %>%
      mutate_at(c(1,14:19,26:44),as.factor) 
    
    dat1$treatment <- factor(dat1$treatment,levels = c('R','O'))
    
    dat2 <-  dat  %>% 
      column_to_rownames('ID') %>% 
      rename('operation_time' = 'operation time', # debug
             'amount_of_bleeding' = 'amount of bleeding', 
             'incisal_margin' = 'incisal margin',
             'B_C' = 'B/C',
             'III_IV' = 'III/IV',
             'long_term' = 'long-term',
             'distance_' = 'distance') %>% 
      mutate_all(~ ifelse(. %in% c("", "NA"), NA, .)) %>% # debug
      # na.omit() %>%  # debug
      mutate_all(~ ifelse(. %in% c('EN'), 'En', .)) %>% # debug
      mutate_at(c(2:13),as.numeric) %>%
      mutate_at(c(1,14:19,26:44),as.factor) 
    
    dat2$treatment <- factor(dat2$treatment,levels = c('R','O'))
    
    
  # PSM 
  psm_dat <- matchit(
    data = dat1,
    formula = as.formula(paste("treatment ~ ", paste0(colnames(dat1)[c(4)], collapse="+"))),
    method = "nearest",
    distance = "glm",
    replace = FALSE,
    ratio = r,
    caliper = c)
  
  summary(psm_dat)
  
  psm_dat_match <- match.data(psm_dat) %>% 
    select(-c('distance','weights','subclass')) 
  write.csv(psm_dat_match,paste0(names(dat_ls)[x],'_psm_matched_clinical_data.csv'))
  
  # comparegroups - psm
  restab <- descrTable(treatment ~ ., data = psm_dat_match,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_psm_result.csv'))
  
  # comparegroups - no_psm
  restab <- descrTable(treatment ~ ., data = dat2,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_no_psm_result.csv'))


