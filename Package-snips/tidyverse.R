
## %% dplyr examples of rename_with for renaming columns
gender <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-19/gender.csv') %>% 
  janitor::clean_names() %>% 
  dplyr::filter(county == "Total") %>% 
  dplyr::rename_with(~ paste0("pop_", .), -dplyr::matches("county"))

dplyr::rename_with(iris, ~ tolower(gsub(".", "_", ., fixed = TRUE)))


## %% tidyr examples of pivot_longer
# (inspired by the melt() and dcast() in data.table)
# and pivot_wider
# (inspired by the cdata package by John Mount and Nina Zumel).
# see tutorial https://tidyr.tidyverse.org/articles/pivot.html

# String data in column names
relig_income
relig_income %>%
  pivot_longer(!religion, names_to = "income", values_to = "count")

# Numeric data in column names
billboard %>%
  pivot_longer(
     cols = starts_with("wk")
    ,names_to = "week"
    ,values_to = "rank" 
    ,values_drop_na = TRUE # drops rows with NA  
    ,names_prefix = "wk" # strips off the col names prefix
    ,names_transform = list(week = as.integer) # converts to int
  ) 

# The above two additional arguments can be done
# in a single argument using readr::parse_number
billboard %>%
  pivot_longer(
    cols = starts_with("wk")
    ,names_to = "week"
    ,values_to = "rank" 
    ,values_drop_na = TRUE # drops rows with NA  
    ,names_transform = list(week = readr::parse_number) # converts to int
  ) 

# Many variables in column names




disability <- rKenyaCensus::V4_T2.27 %>% 
  janitor::clean_names() %>% 
  dplyr::filter(sub_county == "KENYA") %>% 
  dplyr::mutate(county = "Total") %>% 
  dplyr::select(-sub_county, -admin_area) %>% 
  tidyr::pivot_longer(dplyr::contains(c("male", "female", "total")),
                      names_to = c("disability", ".value"),
                      names_sep = "")

disability <- rKenyaCensus::V4_T2.27 %>% 
  janitor::clean_names() %>% 
  dplyr::filter(sub_county == "KENYA") %>% 
  dplyr::mutate(county = "Total") %>% 
  dplyr::select(-sub_county, -admin_area) %>% 
  tidyr::pivot_longer(dplyr::contains(c("male", "female", "total")),
                      names_to = c("disability", ".value"),
                      names_pattern = "(.+)_(.+)")
