library(tidyverse)
library(RSelenium)

# initialization on docker
# docker pull selenium/standalone-firefox:2.53.0
# docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
## run this after initialization on docker

here = "8109 Jeffrey Ct, Fairfax Station, VA 22039"
there = "6003 Goethals Rd, Fort Belvoir, VA 22060"

remDr <- remoteDriver(remoteServerAddr = "192.168.99.100",port = 4445L)
remDr$open()

from = here
to = there

timefunc = function(from, to) {
  # locations = tibble::tibble(from = from, to = to)
  remDr$navigate("https://www.google.com/maps/dir///@41.3725056,-73.9712484,15z/data=!4m2!4m1!3e0")
  remDr$screenshot(display = TRUE)
  Sys.sleep(rlnorm(10,0,1))
  webElem <- remDr$findElement(using = 'id', value = "sb_ifc50")
  webElem$sendKeysToElement(list(from, "\uE007"))
  remDr$screenshot(display = TRUE)
  Sys.sleep(rlnorm(10,0,1))
  webElem2 <- remDr$findElement(using = 'id', value = "sb_ifc51")
  webElem2$sendKeysToElement(list(to, "\uE007"))
  remDr$screenshot(display = TRUE)

  Sys.sleep(rlnorm(10,0,1))
  data <- 
    xml2::read_html(remDr$getPageSource()[[1]]) %>%
    rvest::html_nodes("#section-directions-trip-0 .delay-light span") 
  # rvest::html_children()
  
  data2 =
    data[1] %>% as.character() 
    # data[1] %>% as.character() %>% 
    # str_sub(22,27)
  print(data2) ## can clean this up later
  return(list(data2))
}

time = timefunc(from = here, to = there)

txtony = timefunc(from ="center point, texas", to = "west point, ny")
