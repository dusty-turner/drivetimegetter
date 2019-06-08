library(tidyverse)
library(RSelenium)

# initialization on docker
# docker pull selenium/standalone-firefox:2.53.0
# docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
## run this after initialization on docker

remDr <- remoteDriver(remoteServerAddr = "192.168.99.100",port = 4445L)
remDr$open()

# remDr$navigate("https://www.google.com/maps/dir/8109+Jeffrey+Ct,+Fairfax+Station,+VA+22039/6003+Goethals+Rd,+Fort+Belvoir,+VA+22060/@38.7311954,-77.2367013,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x89b653b765e4f829:0x636c45f69657c46b!2m2!1d-77.2595979!2d38.7363011!1m5!1m1!1s0x89b7ac5e4e44b06f:0x2512db922ee9f3d1!2m2!1d-77.1462428!2d38.714176!3e0")
remDr$navigate("https://www.google.com/maps/dir///@41.3725056,-73.9712484,15z/data=!4m2!4m1!3e0")

remDr$screenshot(display = TRUE)
remDr$findElements
webElem <- remDr$findElement(using = 'id', value = "sb_ifc50")
webElem$sendKeysToElement(list("8109 Jeffrey Ct, Fairfax Station, VA 22039", "\uE007"))
remDr$screenshot(display = TRUE)
webElem2 <- remDr$findElement(using = 'id', value = "sb_ifc51")
webElem2$sendKeysToElement(list("6003 Goethals Rd, Fort Belvoir, VA 22060", "\uE007"))
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