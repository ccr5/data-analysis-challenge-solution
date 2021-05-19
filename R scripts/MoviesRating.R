# Script: Movie Genres X Rating

# Installing a package to MySQL
install.packages("RMySQL")
install.packages("dplyr")

# Importing the libraries
library(RMySQL)
library(ggplot2)
library(dplyr)

# Conecting to the database LooqBox
con = dbConnect(RMySQL::MySQL(),
                dbname = "looqbox_challenge",
                host = "35.199.127.241",
                user = "looqbox-challenge",
                password = "looq-challenge",
                port = 3306
)

# Executing a SQL command to get our datas
sel = dbSendQuery(con, 'select Genre, Year, avg(Rating) as Rating from IMDB_movies 
                        where Genre in ("Action,Adventure,Sci-Fi", 
                        				        "Drama", 
                                        "Comedy,Drama,Romance", 
                                        "Comedy", 
                                        "Drama,Romance") group  by Genre, Year')
dataset = fetch(sel) # records from a previously executed query


# Ploting a chart
ggplot() + 
  geom_line(aes(x = dataset$Year, y = dataset$Rating, color = dataset$Genre)) +
  labs(x = "Year", y = "Avg. of Rating", color = "Movie Genres") +
  ggtitle("Movie Genres Rating X Years")


# Disconecting to the database
dbDisconnect(con)