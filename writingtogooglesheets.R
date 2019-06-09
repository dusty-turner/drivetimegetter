library(googlesheets)
library(tidyverse)

start = gs_title("drivetimes")

# df = 
# start %>%
#   gs_read()

vecdf = tibble(From = from,To = to,Time = unlist(time))

start %>%
gs_add_row(input = vecdf, verbose = TRUE)

gd_token()

# gs_auth("4/ZAGv7ogdwyDYDHeJqPj4_TqvcSO57BRW1-hor75fNsiZXWyLTXnr4pw")


