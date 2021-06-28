# Pivot Longer or Wider

# Load Packages and Data ------
library(tidyverse)
library(here)
library(janitor)

# Import Wide Data ------

wide <- read_csv(here("data",
                      "beachbugs_wide.csv"))

long <- read_csv(here("data",
                      "beachbugs_long.csv"))

# wide to long ------

beach_long = wide %>%
  pivot_longer(names_to = "site",
               values_to = "bug_levels",
               `Bondi Beach`:`Tamarama Beach`)

# long to wide ------

beach_wide = long %>%
  pivot_wider(names_from = site,
              values_from = buglevels)
 