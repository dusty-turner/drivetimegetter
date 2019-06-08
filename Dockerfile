FROM rocker/tidyverse

ADD ./install.sh /usr/local/drivetimegetter/install.sh
ADD ./driveteimegetter.R /usr/local/drivetimegetter/drivetimegetter.R

RUN /usr/local/drivetimegetter/install.sh

# docker build -t drivetimegetter .
# docker run -e PASSWORD=test -p 8787:8787 drivetimegetter