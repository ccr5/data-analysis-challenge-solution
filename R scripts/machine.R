# Installing a package to MySQL
# install.packages("RMySQL")
# install.packages("dplyr")

# Importing the libraries
library(RMySQL)
library(ggplot2)
library(dplyr)

# Conecting to the database
con = dbConnect(RMySQL::MySQL(),
                dbname = "looqbox_challenge",
                host = "35.199.127.241",
                user = "looqbox-challenge",
                password = "looq-challenge",
                port = 3306
)

# Executing a SQL command to get datas
sel = dbSendQuery(con, 'select * from IMDB_movies 
                        where Genre in ("Action,Adventure,Sci-Fi", 
        				        "Drama", 
                        "Comedy,Drama,Romance", 
                        "Comedy", 
                        "Drama,Romance")')
dataset = fetch(sel) # records from a previously executed query
dataset = dataset[, 6:10] # Getting only columns that we'll use



# Encoding the qualitative independent variable (Categorical data)
dataset$Year = factor(dataset$Year,
                       c(2006:2016),
                       c(1:11))

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Rating, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting the multiple linear regression to the Training set
regressor = lm(formula = Rating ~ .,
               data = training_set)

# Predicting the test set results
y_pred = predict(regressor, newdata = test_set)

# Building the optimal model using Backward Elimination (SL > 0.05)
regressor = lm(formula = Rating ~ Year + Runtime + Rating + Votes + RevenueMillions,
               data = dataset)
summary(regressor)

# Remove Year (P-Value > 0.05)
regressor = lm(formula = Rating ~ Runtime + Rating + Votes + RevenueMillions,
               data = dataset)
summary(regressor)

# Runtime, Votes and RevenueMillions are more significant

# Disconecting to the database
dbDisconnect(con)