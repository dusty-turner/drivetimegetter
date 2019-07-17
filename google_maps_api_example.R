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
  
  current_time_min_nyc <-
    Sys.time() %>% with_tz(tzone = "America/New_York") %>% minute()
  
  if (current_time_hour_nyc < 23 & current_time_hour_nyc >= 5) {
    # pull from git to make sure we are fresh
    cred <- git2r::cred_env("GITHUB_UID", "GITHUB_PAT")
    git2r::pull(credentials = cred)
    
    ### read in the pairs of addresses from CSV  -----
    addresses <- read_csv("addresses.csv")
    
    for (i in 1:nrow(addresses)) {
      # don't tell Jenny Bryan that sometimes I find loops easier to grok
      
      to_address <- gsub("\n", "+", addresses[i,]$to)
      from_address <- gsub("\n", "+", addresses[i,]$from)
      
      to_address <- gsub(" ", "+", to_address)
      from_address <- gsub(" ", "+", from_address)
      to_address <- gsub("\r", "+", to_address)
      from_address <- gsub("\r", "+", from_address)
      
      run_name <- addresses[i,]$name
      
      try(get_drive_times(run_name, from_address, to_address))
      
      print(paste("finished row:", i))
    }
  }
  
  # build JDL analysis
  rmarkdown::render(
    here("analysis", "jdl_analysis.Rmd"),
    output_file = here("analysis", "jdl_analysis.html")
  )

  # build DST analysis
  rmarkdown::render(
    here("analysis", "dst_analysis.Rmd"),
    output_file = here("analysis", "dst_analysis.pdf")
  )
  
  # push this all to github automagically!!! ----
  
  try({
    git2r::commit(message = paste("automatic run on:",
                                  format(Sys.time(), '%Y-%m-%d %H:%M')),
                  all = TRUE)
    
    git2r::push(credentials = cred)
  })

  ## dusty's text message dorking around attempts
  try({
    
  if (current_time_hour_nyc == 6 & current_time_hour_nyc <= 16) {
  time = read_csv("drive_times.csv", col_names = FALSE) %>%
      filter(X1=="Dusty") %>%
      filter(substr(X3,1,4)=="6003") %>%
      filter(X4==max(X4)) %>%
      select(X5)
  statement = paste("Your current drive time is between", floor(time$X5/60), "and", ceiling(time$X5/60), "minutes")
  library(twilio)
  Sys.setenv(TWILIO_SID = "AC86efcce023eecaba55949f425edb9283")
  Sys.setenv(TWILIO_TOKEN = "5fdeb09fa990fe1f657a11fcdf4630b3")
  my_phone_number <- "18302855067"
  twilios_phone_number <- "18305223002"
  tw_send_message(from = twilios_phone_number, to = my_phone_number, 
                  body = statement)
  }
  })
  Sys.sleep(900)
}
