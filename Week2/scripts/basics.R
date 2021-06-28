# load packages ------------

# Remember to install the packages first!
# Select the lines and hit run OR press CTRL+ENTER

library(tidyverse)
library(here)
library(skimr)
# New package!
library(janitor)

# read in data -------------

# = can be used instead of "<-"
# remember many function names are close or overlap!!!
# readr::read_csv
beaches <- read_csv(here("data", "sydneybeaches.csv"))

# same thing with code below

beaches <- readr::read_csv(here::here("data", "sydneybeaches.csv"))

# explore data --------------

## view the data like a worksheet -----
View(beaches)

## dimensions -----
dim(beaches)

## structure ------
str(beaches)

## cleaner structure in table -----
glimpse(beaches)

## see first few rows -----
head(beaches)

## see last few rows -----
tail(beaches)

## summary of the data -----
summary(beaches)

# skimr -------
# install first! install.packages("skimr")

skim(beaches)


# tidying beaches --------------

## testing select_all ---------
select_all(beaches, toupper)

select_all(beaches, tolower)

## easier with janitor -----
# note the `janitor::` is unnessary since
## library(janitor is called already in the script)
janitor::clean_names(beaches)
# Note we have NOT actually cleaned beaches yet!

cleanbeaches = clean_names(beaches)

# check new data frame 
str(cleanbeaches)

### are the names changed though? -------
# `all` tests logicals and `==` tests "are these equal"
all(names(beaches) == names(cleanbeaches))

## rename enterococci ----

# Note that we have to reassign cleanbeaches again to save the renaming!
cleanbeaches = rename(cleanbeaches, beachbugs = enterococci_cfu_100ml)

# Pipes %>% FTW ----

### "Ceci n'est pas une pipe" ###

# remove cleanbeaches
rm(cleanbeaches)

## create cleanbeaches with a pipe -----

cleanbeaches = beaches %>%
  clean_names() %>% # clean columns
  rename(beachbugs = enterococci_cfu_100ml)  # rename

# export cleanbeaches ----
write_csv(cleanbeaches, "data/cleanbeaches.csv")
# but note that it saves the file to root of your project

# Arrange those bugs! -------
## show beaches with worst bugs --
worstbugs = cleanbeaches %>% 
  arrange(desc(beachbugs))

## reduce to coogee beach

worstcoogee = cleanbeaches %>% 
  filter(site == "Coogee Beach") %>%
  arrange(-beachbugs)

worst2 = cleanbeaches %>%
  filter(site == "Coogee Beach" | site == "Malabar Beach") %>%
  arrange(-beachbugs)

# Summarize beaches -------

## Which beach has the worst bacteria levels on average? -------

sum1 = cleanbeaches %>%
  group_by(site) %>% # group data
  # then we summarize!
  summarize(mean_bugs = mean(beachbugs, 
                             na.rm = TRUE), # na.rm removes the missing data
            sd_bugs = sd(beachbugs,
                         na.rm = TRUE),
            max_bugs = max(beachbugs,
                           na.rm = TRUE),
            .groups = 'drop') # drops organizing category

# Export summaries
write_csv(sum1, "sum1.csv")

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

## seperate date -----------
testdate = cleanbeaches %>%
  separate(date, c("day","month","year"), 
           remove = FALSE )

### Take a Look -------------

testdate %>%
  select(beach_id, date,day,month,year) %>%
  head()

## unite council and site

cleanbeaches = cleanbeaches %>%
  unite(council_site,council:site) # unite creates a single "united" variable

cleanbeaches = cleanbeaches %>%
  mutate(council_site = paste0(council,"_",site),
         region_site = paste0(beach_id,"_",site))

## Mutate: Log beachbugs --------

cleanbeaches = cleanbeaches %>%
  mutate(logbeachbugs = log(beachbugs+1))

## Mutate: diff beachbugs ----------

cleanbeaches = cleanbeaches %>%
  mutate(beachbugsdiff = beachbugs - lag(beachbugs))

## Mutate: logical variable

cleanbeaches = cleanbeaches %>%
  # compute TRUE/FALSE if bugs greater than average
  # though the median is probably a better metric here.
  mutate(buggier = beachbugs > mean(beachbugs, na.rm=TRUE))


# All in 1 step ----
rm(cleanbeaches)
# Pipes!!!!

cleanbeaches = beaches %>%
  clean_names() %>% # clean columns
  rename(beachbugs = enterococci_cfu_100ml)  %>%
  separate(date, c("day","month","year"),
           remove = FALSE) %>%
  #unite(council_site,council:site) %>%
  mutate(logbeachbugs = log(beachbugs),
         beachbugsdiff = beachbugs - lag(beachbugs),
         buggier = beachbugs > mean(beachbugs, na.rm=TRUE))


# Pivot ------
  

