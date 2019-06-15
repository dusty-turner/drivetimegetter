library(tidyverse)
library(gmapsdistance)

## gmapsdistance key register
set.api.key(Sys.getenv("GOOG_MAPS_API"))

## start with a csv of to/from address pairs ----
## using an example pair for testing ---
to_address <- "215+N+Jefferson+st.+clinton,+ky+42031"
from_address <- "5100+monument+ave+richmond,+va+23230"

gmapsdistance(origin = from_address,
              destination = to_address,
              mode = "driving", 
              traffic_model = "best_guess") %>%
  as.data.frame %>%
  mutate(from = from_address, 
         to = to_address,
         run_date = Sys.time()) %>%
  select(from, to, run_date, Time, Distance, Status) -> 
  drive_time

drive_time %>%
  write_csv("drive_times.csv", append=TRUE)

# push this all to github automagically!!! ----

cred <- git2r::cred_env("GITHUB_UID", "GITHUB_PAT")
git2r::pull(credentials = cred)
git2r::commit(message = paste(
  "automatic run on:",
  format(Sys.time(), '%Y-%m-%d %H:%M')
),
all = TRUE)

git2r::push(credentials = cred)


