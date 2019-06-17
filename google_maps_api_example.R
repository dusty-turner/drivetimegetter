library(tidyverse)
library(gmapsdistance)

## function takes a two addresses and updates the output csv with drive times ----

get_drive_times <- function(from_address, to_address) {
  ## using an example pair for testing ---
  
  gmapsdistance(
    origin = from_address,
    destination = to_address,
    mode = "driving",
    traffic_model = "best_guess"
  ) %>%
    as.data.frame %>%
    mutate(from = from_address,
           to = to_address,
           run_date = Sys.time()) %>%
    select(from, to, run_date, Time, Distance, Status) ->
    drive_time
  
  drive_time %>%
    write_csv("drive_times.csv", append = TRUE)
}

## gmapsdistance key register
set.api.key(Sys.getenv("GOOG_MAPS_API"))

### read in the pairs of addresses from CSV  -----
addresses <- read_csv("addresses.csv")

for (i in 1:nrow(addresses)) {
  # don't tell Jenny Bryan that sometimes I find loops easier to grok
  
  to_address <- gsub(" ", "+", addresses[i, ]$to)
  from_address <- gsub(" ", "+", addresses[i, ]$from)
  
  
  get_drive_times(to_address, from_address)
  print(paste("finished row:", i))
  
}

# push this all to github automagically!!! ----

cred <- git2r::cred_env("GITHUB_UID", "GITHUB_PAT")
git2r::pull(credentials = cred)
git2r::commit(message = paste("automatic run on:",
                              format(Sys.time(), '%Y-%m-%d %H:%M')),
              all = TRUE)

git2r::push(credentials = cred)
