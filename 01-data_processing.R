

##### Code except for MP and EN sheet -------------------------------------------------------------------------------------------------------

rm(list = ls());gc()

# load package
library(rio)
library(tidyverse)
library(MatchIt)
library(compareGroups)

# load data
path <- 'Data/net整理数据库0221-6.xlsx'
dat_ls <- import_list(path) 
dat_ls <- dat_ls[c(1:3,6)]

for (x in 1:length(dat_ls)) {
  
  dat <- dat_ls[[x]] 
  
  dat[grep('<0.5',dat$CEA),'CEA'] <- 0.5 # debug
  dat[grep('<0.8',dat$CA99),'CA99'] <- 0.8 # debug
  
  if (ncol(dat) == 56) {
    
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
      mutate_at(c(2:21),as.numeric) %>%
      mutate_at(c(1,22:30,37:55),as.factor) 
    
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
      mutate_at(c(2:21),as.numeric) %>%
      mutate_at(c(1,22:30,37:55),as.factor) 
    
  } else if (ncol(dat) == 54){
    
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
      mutate_at(c(2:20),as.numeric) %>%
      mutate_at(c(1,21:28,35:53),as.factor) 
    
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
      mutate_at(c(2:20),as.numeric) %>%
      mutate_at(c(1,21:28,35:53),as.factor) 
    
  }
  
  if (ncol(dat) == 56) {
    
  # PSM 
  psm_dat <- matchit(
    data = dat1,
    formula = as.formula(paste("Treatment ~ ", paste0(colnames(dat)[c(2:30)], collapse="+"))),
    method = "nearest",
    distance = "glm",
    replace = FALSE,
    ratio=1,
    caliper = 0.5)
  
  } else if (ncol(dat) == 54){
  
  # PSM 
  psm_dat <- matchit(
    data = dat1,
    formula = as.formula(paste("Treatment ~ ", paste0(colnames(dat)[c(2:28)], collapse="+"))),
    method = "nearest",
    distance = "glm",
    replace = FALSE,
    ratio=1,
    caliper = 0.5)
  
  }
  
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

rm(list = ls());gc()

# load package
library(rio)
library(tidyverse)
library(MatchIt)
library(compareGroups)

# load data
path <- 'Data/net整理数据库0221-6.xlsx'
dat_ls <- import_list(path) 
dat_ls <- dat_ls[4:5]

for (x in 1:length(dat_ls)) {
  
  dat <- dat_ls[[x]] 
  
  dat[grep('<0.5',dat$CEA),'CEA'] <- 0.5 # debug
  dat[grep('<0.8',dat$CA99),'CA99'] <- 0.8 # debug
  
  if (ncol(dat) == 56) {
    
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
      mutate_at(c(2:21),as.numeric) %>%
      mutate_at(c(1,22:30,37:55),as.factor) 
    
  } else if (ncol(dat) == 54){
  
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
      mutate_at(c(2:20),as.numeric) %>%
      mutate_at(c(1,21:28,35:53),as.factor) 
    
  }
  
  # comparegroups - no_psm
  restab <- descrTable(treatment ~ ., data = dat2,method = NA,digits = 2)
  export2csv(restab, file = paste0(names(dat_ls)[x],'_no_psm_result.csv'))
  
}
