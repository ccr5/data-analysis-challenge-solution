# Script: Question 5: Graphics

# Installing a package to MySQL
install.packages("RMySQL")
install.packages("dplyr")

# Importing the libraries
library(RMySQL)
library(ggplot2)
library(dplyr)


# First chart

# Conecting to the database LooqBox
con = dbConnect(RMySQL::MySQL(),
                dbname = "looqbox_challenge",
                host = "35.199.127.241",
                user = "looqbox-challenge",
                password = "looq-challenge",
                port = 3306
)

# Executing a SQL command to get our datas
sel = dbSendQuery(con, "SELECT 
                            data_product.DEP_NAME AS DEPARTAMENTO,
                            SUM(data_product_sales.SALES_QTY) AS QTD_VENDAS
                        FROM
                            data_product_sales
                                INNER JOIN
                            data_product ON (data_product.PRODUCT_COD = data_product_sales.PRODUCT_CODE)
                        WHERE
                            DATE BETWEEN '2019-01-01' AND '2019-03-31'
                        GROUP BY DEP_NAME")
dataset = fetch(sel) # records from a previously executed query

# Adding the Thousand Scale
for(i in c(1:length(dataset$QTD_VENDAS))) {
  dataset$QTD_VENDAS[[i]] = dataset$QTD_VENDAS[[i]] / 1000
}

# Shortening the name to fit the chart
dataset$DEPARTAMENTO[[6]] = "GENÉRICOS"
dataset$DEPARTAMENTO[[7]] = "REFERÊNCIA"

# Ordering the dataset
dataset$DEPARTAMENTO = factor(dataset$DEPARTAMENTO, levels=dataset$DEPARTAMENTO[order(dataset$QTD_VENDAS)], 
                              ordered=TRUE)


# Ploting the first Graphic
ggplot(dataset, aes(DEPARTAMENTO, QTD_VENDAS)) + 
  geom_bar(stat= "identity") + 
  labs(x = "Departamento", y = "Number of sales (thousands)") +
  ggtitle("Number of sales (thousands) by Department")


# Second chart

# Executing a SQL command to get our datas
sel = dbSendQuery(con, "SELECT 
                            data_product.DEP_NAME AS DEPARTAMENTO,
                            SUM(data_product_sales.SALES_QTY) AS QTD_VENDAS
                        FROM
                            data_product_sales
                                LEFT JOIN
                            data_product ON (data_product.PRODUCT_COD = data_product_sales.PRODUCT_CODE)
                        WHERE
                            DATE BETWEEN '2019-01-01' AND '2019-03-31'
                        GROUP BY DEP_NAME")
dataset = fetch(sel) # records from a previously executed query

# Adding the Thousand Scale
for(i in c(1:length(dataset$QTD_VENDAS))) {
  dataset$QTD_VENDAS[[i]] = dataset$QTD_VENDAS[[i]] / 1000
}

# Shortening the name to fit the chart
dataset$DEPARTAMENTO[[7]] = "GENÉRICOS"
dataset$DEPARTAMENTO[[8]] = "REFERÊNCIA"

# Ordering the dataset
dataset$DEPARTAMENTO = factor(dataset$DEPARTAMENTO, levels=dataset$DEPARTAMENTO[order(dataset$QTD_VENDAS)], 
                              ordered=TRUE)


# Ploting the second Graphic
ggplot(dataset, aes(DEPARTAMENTO, QTD_VENDAS)) + 
  geom_bar(stat= "identity") + 
  labs(x = "Departamento", y = "Number of sales (thousands)") +
  ggtitle("Number of sales (thousands) by Department")


# Disconecting to the database
dbDisconnect(con)