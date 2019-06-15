library(tidyverse)
library(gmapsdistance)

## gmapsdistance key register
set.api.key(Sys.getenv("GOOG_MAPS_API"))

## start with a csv of to/from address pairs ----
## using an example pair for testing ---
to_address <- "215+N+Jefferson+st.+clinton+ky+42031"
from_address <- "5100+monument+ave+richmond+va+23230"

gmapsdistance(origin = from_address,
              destination = to_address,
              mode = "driving")
