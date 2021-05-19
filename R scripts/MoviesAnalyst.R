# Script: Movie Genres X Year

# Installing a package to MySQL
install.packages("RMySQL")
install.packages("dplyr")

# Importing the libraries
library(RMySQL)
library(ggplot2)
library(dplyr)

# Conecting to the database LooqBox
con = dbConnect(RMySQL::MySQL(),
                dbname = "challenge",
                host = "xx.xxx.xxx.241",
                user = "challenge",
                password = "challenge",
                port = 3306
)

# Executing a SQL command to get our datas
sel = dbSendQuery(con, 'select Genre, Year, count(Year) as Value from IMDB_movies 
                        where Genre in ("Action,Adventure,Sci-Fi", 
                        				        "Drama", 
                                        "Comedy,Drama,Romance", 
                                        "Comedy", 
                                        "Drama,Romance") group  by Genre, Year')
dataset = fetch(sel) # records from a previously executed query


# Ploting a chart
ggplot() + 
  geom_line(aes(x = dataset$Year, y = dataset$Value, color = dataset$Genre)) +
  labs(x = "Year", y = "Number of movies", color = "Movie Genres") +
  ggtitle("Growth of Movie Genres")


# Disconecting to the database
dbDisconnect(con)