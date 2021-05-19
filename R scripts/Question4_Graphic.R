# Script: Question 4: Graphic

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
sel = dbSendQuery(con, 'select	DATE as DATA, 
                        		    SALES_QTY as QTD_VENDAS, 
                                data_product_sales.STORE_CODE as C�D_DA_LOJA, 
                                data_store_cad.STORE_NAME as NOME_DA_LOJA from data_product_sales 
                                inner join data_store_cad on (data_product_sales.STORE_CODE = data_store_cad.STORE_CODE) order by SALES_QTY DESC limit 10')
dataset = fetch(sel) # records from a previously executed query
dataset = dataset[,1:2] # Getting only columns that I'll use

# Ploting a chart
ggplot() + 
  geom_line(aes(x = dataset$DATA, y = dataset$QTD_VENDAS, group = 1)) +
  geom_text(aes(x = dataset$DATA, y = dataset$QTD_VENDAS, label = dataset$QTD_VENDAS)) +
  labs(x = "Dates", y = "Numbers of sales") +
  ggtitle("The most number of sales in Rio de Janeiro store")
