library(googlesheets)
library(tidyverse)

uploader = function(from, to, time) {

start = gs_title("drivetimes")

vecdf = tibble(From = from,To = to,Time = time)

start %>%
gs_add_row(input = vecdf, verbose = TRUE)

}

uploader(from = flwtowsmr$from, to = flwtowsmr$to, time = flwtowsmr$data2)

# gs_auth("4/ZAGv7ogdwyDYDHeJqPj4_TqvcSO57BRW1-hor75fNsiZXWyLTXnr4pw")