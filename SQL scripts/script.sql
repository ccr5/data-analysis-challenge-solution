-- SQL Test
use looqbox_challenge;

# 1. How many products does the company have?
select count(PRODUCT_COD) as QTD_PRODUTOS_CADASTRADOS from data_product;
-- There are 9994 products registered.


# 2. What are the 10 most expensive products in the company?
select PRODUCT_COD as CÓDIGO, PRODUCT_NAME as NOME, PRODUCT_VAL as PRECO_UNITARIO_R$ from data_product order by PRODUCT_VAL desc limit 10;
-- COD: 301409, 176185, 315481, 100280, 320046, 190817, 153795, 311397, 147706, 154431


# 3. What sections do the 'BEBIDAS' and 'PADARIA' departments have?
select min(SECTION_COD) as CÓDIGO, SECTION_NAME as SESSÃO from data_product where DEP_NAME = "BEBIDAS" or DEP_NAME = "PADARIA" group by SECTION_NAME;
-- Bebidas, cervejas, doces e sobremesas, gestante, padaria, queijos e frios, refrescos, vinhos


# 4. When were the most products sold? In which store?
select	DATE as DATA, 
		SALES_QTY as QTD_VENDAS, 
        data_product_sales.STORE_CODE as CÓD_DA_LOJA, 
        data_store_cad.STORE_NAME as NOME_DA_LOJA from data_product_sales 
        inner join data_store_cad on (data_product_sales.STORE_CODE = data_store_cad.STORE_CODE) order by SALES_QTY DESC limit 10;
-- All dates are from Rio de Janeiro, cod. 11 at 2019.


# 5. Bonus!! What was the total sale of the products of each business area in the first quarter of 2019?
SELECT 
    data_product.DEP_NAME AS DEPARTAMENTO,
    SUM(data_product_sales.SALES_QTY) AS QTD_VENDAS
FROM
    data_product_sales
        LEFT JOIN
    data_product ON (data_product.PRODUCT_COD = data_product_sales.PRODUCT_CODE)
WHERE
    DATE BETWEEN '2019-01-01' AND '2019-03-31'
GROUP BY DEP_NAME;

-- Total sales
select sum(SALES_QTY) from data_product_sales where DATE between "2019-01-01" and "2019-03-31";



-- Data analyst

-- Select only to see what is the top 10 genres to use in the next select
select Genre, count(Genre) as Number_Movies from IMDB_movies group by Genre order by count(Genre) desc; 

-- Archive: MoviesAnalyst.R
select Genre, Year, count(Year) as Value from IMDB_movies 
where Genre in ("Action,Adventure,Sci-Fi", 
				"Drama", 
                "Comedy,Drama,Romance", 
                "Comedy", 
                "Drama,Romance") group  by Genre, Year;

-- Archive: MoviesRating.R
select Genre, Year, avg(Rating) as Rating from IMDB_movies 
where Genre in ("Action,Adventure,Sci-Fi", 
				"Drama", 
                "Comedy,Drama,Romance", 
                "Comedy", 
                "Drama,Romance") group  by Genre, Year;
                
-- Machine Learning
select * from IMDB_movies where Genre in ("Action,Adventure,Sci-Fi", 
				"Drama", 
                "Comedy,Drama,Romance", 
                "Comedy", 
                "Drama,Romance");
