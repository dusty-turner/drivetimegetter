# drivetimegetter

Fire up a small digital ocean docker machine:
`docker-machine create --digitalocean-size "s-1vcpu-1gb" --driver digitalocean --digitalocean-access-token $DO_PAT drivetimegetter`

assumes there is an environment variable named `DO_PAT` that contains the DO access token. 

then run 

`eval $(docker-machine env drivetimegetter)` to set up some environment variables so we can connect

`docker run -d -e PASSWORD=XXXXXXXXX -p 8787:8787 rocker/tidyverse` will start the Docker instance

`docker-machine ip drivetimegetter` shows the IP address... now connect to that IP:8787

