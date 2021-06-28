# see https://ggplot2.tidyverse.org/ for details on visualizations
# load packages -----
library(tidyverse)
library(here)
# new package
library(ggbeeswarm)


# Load cleanbeaches_new.csv --------

plotbeaches = read_csv(here("data", "cleanbeaches_new.csv"))

# Also, source("basics.R") will run the basics script 
# objects from that script would be added to your environment

# Plot Bugs! ------
# parentheses outputs the plot
(
  p1 = plotbeaches %>% 
   ggplot(aes(x=year,y=beachbugs))+
   geom_point()
) 

## summarize obs per group -----

(
  sum1 = plotbeaches %>% 
    group_by(year) %>%
    summarize(obs = n())
) # too many observations for geom_point!

## Plot again with jitter -----

(
  p2 = plotbeaches %>% 
    ggplot(aes(x=year,y=beachbugs))+
    geom_jitter()
) 

## Plot jitter with colors -----

(
  p3 = plotbeaches %>% # get data
    na.omit() %>% # remove missing data
    mutate(site = as.factor(site)) %>% # ensure site is a factor
    ggplot(aes(x = year,
               y = beachbugs,
               color = site)) + # assign color by site
    geom_jitter() + # plot as a jittered points
    coord_flip() # flip coordinates
) 

## Add facets to the plot ------

(
  p4 = plotbeaches %>% # get data
    na.omit() %>% # remove missing data
    mutate(site = as.factor(site)) %>% # ensure site is a factor
    ggplot(aes(x = year,
               y = beachbugs,
               color = council)) + # assign color by site
    geom_jitter() + # plot as a jittered points
    facet_wrap(~site) # create facets that are seperated by site
) 

## Add a filter for outliers ------

(
  p5 = plotbeaches %>% # get data
    na.omit() %>% # remove missing data
    mutate(site = as.factor(site)) %>% # ensure site is a factor
    filter(beachbugs < 1000) %>%
    ggplot(aes(x = year,
               y = beachbugs,
               color = site)) + # assign color by site
    geom_jitter() + # plot as a jittered points
    facet_wrap(~site) # create facets that are seperated by site
) 

## Add a filter for outliers AND site ------

(
  p6 = plotbeaches %>% # get data
    na.omit() %>% # remove missing data
    mutate(site = as.factor(site)) %>% # ensure site is a factor
    filter(beachbugs < 1000,
           site %in% c("Coogee Beach", "Bondi Beach")) %>%
    ggplot(aes(x = year,
               y = beachbugs,
               color = site)) + # assign color by site
    geom_jitter() + # plot as a jittered points
    facet_wrap(~site)   # create facets that are seperated by site 
  
)

# Save plot 6 -----

ggsave(here("output", "coogeebondi.pdf"),
       p6)

# Plot boxplot and violins ------

(
  p_box1 = plotbeaches %>%
    drop_na() %>%
    ggplot(aes(x = site,
               y = log(beachbugs+1)))+
    geom_boxplot() +
    coord_flip()
)

(
  p_vio2 = plotbeaches %>%
    drop_na() %>%
    filter(buggier_site == TRUE) %>%
    mutate(year = as.factor(year)) %>%
    ggplot(aes(x = year,
               y = log(beachbugs+1),
               color = year,
               fill = year))+
    geom_violin() +
    facet_wrap(~site)
)

# Violin with fill and color ------
(
  p_vio1 = plotbeaches %>%
    drop_na() %>%
    mutate(year = as.factor(year)) %>%
    ggplot(aes(x = year,
               y = log(beachbugs+1)))+
    geom_violin() 
)

# Histogram ------

(
  p_hist = plotbeaches %>%
    drop_na() %>%
    filter(site == "Clovelly Beach",
           year == "2018") %>%
    ggplot(aes(x=(beachbugs+1))) +
             geom_histogram(binwidth = 1) + 
    scale_x_continuous(trans = "log")
)

# Combination Plot -----

(
  p_comb1 = plotbeaches %>%
    drop_na() %>%
    filter(buggier_site == "TRUE") %>%
    mutate(year = as.factor(year)) %>%
    ggplot(aes(y=log(beachbugs+1),
               x=site)) +
    geom_boxplot()+
    geom_point(aes(color=year))+
    coord_flip()
)

(
  p_comb2 = plotbeaches %>%
    drop_na() %>%
    filter(buggier_site == "TRUE") %>%
    mutate(year = as.factor(year)) %>%
    ggplot(aes(y=log(beachbugs+1),
               x=year)) +
    geom_violin()+
    geom_quasirandom(aes(color=site))
)

# Plot Mean on Bar Plot ------

## Note from Aaron:
### I hate bar plots for continuous data; DO NOT USE THEM FOR PUBLICATIONS!!!

(
  p_bar = plotbeaches %>%
    drop_na() %>%
    group_by(year, site) %>%
    # Deviation: plot mean of log(beachbugs+1)
    summarize(meanbugs = mean(log(beachbugs+1)),
              .groups = 'drop') %>%
    ggplot(aes(x=year,
               y=meanbugs)) +
    geom_col() +
    facet_wrap(~site)
)

(
  p_bar2 = plotbeaches %>%
    drop_na() %>%
    group_by(site) %>%
    # Deviation: plot mean of log(beachbugs+1)
    summarize(meanbugs = mean(log(beachbugs+1)),
              sd = sd(log(beachbugs+1)),
              n = n(),
              stderr = sd/sqrt(n),
              .groups = 'drop') %>%
    ggplot(aes(x=site,
               y=meanbugs,
               ymin = meanbugs-sd,
               ymax = meanbugs+sd)) +
    geom_col() +
    geom_errorbar() +
    coord_flip()
)

# Rain Temps Data ------

raintemp = read_csv(here("data", "rain_temp_beachbugs.csv"))

## Association plot ----

# Deviation
(
  p_rain1 = raintemp %>%
    filter(beachbugs > 500) %>%
    ggplot(aes(x=rain_mm,
               y=beachbugs,
               color=temp_airport)) +
    geom_point() +
    geom_smooth()
)

# Change theme ----

(
  p_rainclassic = raintemp %>%
    filter(beachbugs > 500) %>%
    ggplot(aes(x=rain_mm,
               y=beachbugs,
               color=temp_airport)) +
    geom_point() +
    geom_smooth() +
    theme_classic()
)


# Adjust color gradient -----
(
  p_rainbrewer1 = raintemp %>%
    filter(beachbugs > 500) %>%
    ggplot(aes(x=rain_mm,
               y=beachbugs,
               color=temp_airport)) +
    geom_point() +
    geom_smooth() +
    theme_classic() +
    scale_color_gradient(low = "blue", high = "red")
)

# Adjust color: distiller --- 
(
  p_rainbrewer1 = raintemp %>%
    filter(beachbugs > 500) %>%
    ggplot(aes(x=rain_mm,
               y=beachbugs,
               color=temp_airport)) +
    geom_point() +
    geom_smooth() +
    theme_classic() +
    scale_color_distiller(palette = "RdYlBu")
)

# Adjust labels ----

(
  p_total = raintemp %>%
    filter(beachbugs > 500) %>%
    ggplot(aes(x=rain_mm,
               y=beachbugs,
               color=temp_airport)) +
    geom_point() +
    geom_smooth(method = "loess",
                formula = "y ~ x") +
    theme_classic() +
    scale_color_distiller(palette = "RdYlBu") +
    labs(x = "Rainfall (mm)",
         y = "Mean enterococci bacteria levels",
         color = "Temperature at Airport (°C)") +
    theme(legend.position = "top")
)

# My preference -----

(
  p_rainalt1 = raintemp %>%
    drop_na() %>%
    # Create 4 bins of temperature
    mutate(temp_bin = cut_number(temp_airport,4)) %>%
    ggplot(aes(x=log(rain_mm+1),
               y=log(beachbugs+1),
               color=temp_airport)) +
    geom_point() +
    geom_smooth(method = "lm",
                se = FALSE,
                formula = y ~ x) +
    theme_classic() +
    scale_color_viridis_c(option = "plasma") +
    labs(x = "log(rainfall [mm] + 1)",
         y = "log(enterococci + 1)",
         color = "Temperature at Airport (°C)") +
    facet_wrap(~temp_bin) +
    theme(legend.position = "top")
)

(
  p_rainalt2 = raintemp %>%
    drop_na() %>%
    filter(log(rain_mm +1) != 0) %>%
    # Create 4 bins of temperature
    mutate(temp_bin = cut_number(temp_airport,4)) %>%
    ggplot(aes(x=log(rain_mm+1),
               y=log(beachbugs+1),
               color=temp_airport)) +
    #geom_point() +
    geom_density_2d_filled(contour_var = "count",
                           alpha = .5) +
    geom_density_2d(contour_var = "count",
                    size = 0.5, colour = "black") +
    geom_smooth(method = "lm",
                se = FALSE,
                formula = y ~ x) +
    theme_classic() +
    scale_fill_brewer() +
    labs(x = "log(rainfall [mm] + 1)",
         y = "log(enterococci + 1)",
         fill = "Observations",
         caption = "Note: Zeros removed from rainfall data") +
    scale_y_continuous(expand=c(0,0)) +
    scale_x_continuous(expand=c(0,0)) +
    #facet_wrap(~temp_bin) +
    theme(legend.position = "bottom")
)


# Alternative to plot 6 ------

### I will explain!
library(ggdist)
(
  p6alt = plotbeaches %>% # get data
    na.omit() %>% # remove missing data
    mutate(site = as.factor(site)) %>% # ensure site is a factor
    filter(site %in% c("Coogee Beach", "Bondi Beach")) %>%
    ggplot(aes(x = as.factor(year),
               y = (beachbugs+1),
               color = site)) + # assign color by site
    facet_wrap(~site) + # create facets that are seperated by site 
    stat_halfeye(.width = .5) +
    scale_y_continuous(trans = "log") +
    labs(x = "Year",
         y = "log(enterococci + 1)",
         fill = "Site") +
    scale_color_viridis_d(option = "E") +
    theme_tidybayes() +
    theme(legend.position = "top")
) 

