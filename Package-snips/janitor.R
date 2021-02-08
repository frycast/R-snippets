
## %% Save yourself some greps

gender <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-19/gender.csv') %>% 
  janitor::clean_names() 
janitor::make_clean_names(gender$county)
