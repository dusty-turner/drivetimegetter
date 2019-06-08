timefunc = function(from, to) {
  locations = tibble::tibble(from = from, to = to)
  return(locations)
}

timefunc(from = c("here", "andhere"), to = c("there", "andthere"))
