library(tidyverse)
library(RSelenium)

## run this after initialization on docker

remDr <- remoteDriver(remoteServerAddr = "localhost",port = 4445L)
remDr$open()

remDr$navigate("https://www.google.com/maps/dir/8109+Jeffrey+Ct,+Fairfax+Station,+VA+22039/6003+Goethals+Rd,+Fort+Belvoir,+VA+22060/@38.7311954,-77.2367013,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x89b653b765e4f829:0x636c45f69657c46b!2m2!1d-77.2595979!2d38.7363011!1m5!1m1!1s0x89b7ac5e4e44b06f:0x2512db922ee9f3d1!2m2!1d-77.1462428!2d38.714176!3e0")

remDr$screenshot(display = TRUE)

data <- 
  xml2::read_html(remDr$getPageSource()[[1]]) %>%
  rvest::html_nodes("#section-directions-trip-0 .delay-light span") 
# rvest::html_children()

data2 =
  data[1] %>% as.character() %>% str_sub(22,27)

## this gets the drivetime in character format at this moment.
## after I can get this running on AWS with whatever magic it takes,
## I plan on saving this in a google spreadsheet (thanks Jenny Bryan)
## where I can make confidence intervals.  I also plan on extending
## this to some other drive locations too -- such as the pentagon and
## my favorite bar afterwork and my kids school :)

