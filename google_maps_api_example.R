library(tidyverse)
library(lubridate)
library(gmapsdistance)
library(here)

## function takes a two addresses and updates the output csv with drive times ----

get_drive_times <- function(run_name, from_address, to_address) {
  ## using an example pair for testing ---
  
  gmapsdistance(
    origin = from_address,
    destination = to_address,
    mode = "driving",
    traffic_model = "best_guess"
  ) %>%
    as.data.frame %>%
    mutate(
      run_name = run_name,
      from = from_address,
      to = to_address,
      run_date = Sys.time()
    ) %>%
    select(run_name, from, to, run_date, Time, Distance, Status) ->
    drive_time
  
  drive_time %>%
    write_csv("drive_times.csv", append = TRUE)
  
  print(Sys.time() %>% with_tz(tzone = "America/New_York"))
}

## gmapsdistance key register
set.api.key(Sys.getenv("GOOG_MAPS_API"))

repeat {
  ## only run from 5:00 to 20:00
  current_time_hour_nyc <-
    Sys.time() %>% with_tz(tzone = "America/New_York") %>% hour()
  
  if (current_time_hour_nyc < 23 & current_time_hour_nyc >= 5) {
    # pull from git to make sure we are fresh
    cred <- git2r::cred_env("GITHUB_UID", "GITHUB_PAT")
    git2r::pull(credentials = cred)
    
    ### read in the pairs of addresses from CSV  -----
    addresses <- read_csv("addresses.csv")
    
    for (i in 1:nrow(addresses)) {
      # don't tell Jenny Bryan that sometimes I find loops easier to grok
      
      to_address <- gsub("\n", "+", addresses[i, ]$to)
      from_address <- gsub("\n", "+", addresses[i, ]$from)
      
      to_address <- gsub(" ", "+", to_address)
      from_address <- gsub(" ", "+", from_address)
      to_address <- gsub("\r", "+", to_address)
      from_address <- gsub("\r", "+", from_address)
      
      run_name <- addresses[i, ]$name
      
      try(get_drive_times(run_name, from_address, to_address))
      
      print(paste("finished row:", i))
    }
  }
  
  # build JDL analysis
  rmarkdown::render(
    here("analysis", "jdl_analysis.Rmd"),
    output_file = here("analysis", "jdl_analysis.html")
  )
  
  # push this all to github automagically!!! ----
  
  git2r::commit(message = paste("automatic run on:",
                                format(Sys.time(), '%Y-%m-%d %H:%M')),
                all = TRUE)
  
  git2r::push(credentials = cred)
  Sys.sleep(900)
}
