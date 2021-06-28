# load packages ------------

# Remember to install the packages first!
# Select the lines and hit run OR press CTRL+ENTER

library(tidyverse)
library(here)
library(janitor)

# rdata -------------

# = can be used instead of "<-"
# remember many function names are close or overlap!!!
# readr::read_csv
beaches <- read_csv(here("data", "sydneybeaches.csv"))

# clean -----

## create cleanbeaches with a pipe -----

cleanbeaches = beaches %>%
  clean_names() %>% # clean columns
  rename(beachbugs = enterococci_cfu_100ml)  # rename

# export cleanbeaches ----
write_csv(cleanbeaches, "data/cleanbeaches.csv")
# but note that it saves the file to root of your project

# Arrange those bugs! -------
## show beaches with worst bugs --
worstbugs = cleanbeaches %>% arrange(desc(beachbugs))

## reduce to coogee beach

worstcoogee = cleanbeaches %>% 
  filter(site == "Coogee Beach") %>%
  arrange(-beachbugs)

# Summarize beaches -------

## Which beach has the worst bacteria levels on average? -------

cleanbeaches %>%
  group_by(site) %>% # group data
  # then we summarize!
  summarize(mean_bugs = mean(beachbugs, 
                             na.rm = TRUE), # na.rm removes the missing data
            sd_bugs = sd(beachbugs,
                         na.rm = TRUE),
            max_bugs = max(beachbugs,
                           na.rm = TRUE),
            .groups = 'drop') # drops organizing category

## compare councils ---------

cleanbeaches %>%
  group_by(council, site) %>% # group data
  # then we summarize!
  summarize(mean_bugs = mean(beachbugs, 
                             na.rm = TRUE), # na.rm removes the missing data
            med_bugs = median(beachbugs,
                         na.rm = TRUE),
            .groups = 'drop') # drops organizing category
# Compute Variables --------

cleanbeaches = beaches %>%
  clean_names() %>% # clean columns
  rename(beachbugs = enterococci_cfu_100ml)  %>%
  separate(date, c("day","month","year"),
           remove = FALSE) %>%
  #unite(council_site,council:site) %>%
  mutate(logbeachbugs = log(beachbugs),
         beachbugsdiff = beachbugs - lag(beachbugs),
         buggier = beachbugs > mean(beachbugs, na.rm=TRUE))

cleanbeaches_new = cleanbeaches %>%
  group_by(site) %>%
  mutate(buggier_site = beachbugs > mean(beachbugs, na.rm=TRUE))

# export
write_csv(cleanbeaches_new, "data/cleanbeaches_new.csv")
  

