/*=============================================================================
  PROJET : Analyse Commerciale et Financière des Ventes de Pizzas
  AUTEUR : Brice Abogo
  SGBD   : Microsoft SQL Server (T-SQL)
  BASE   : Pizzas (Table : dbo.pizzas_sales)
  OBJET  : Typage des données, contrôle qualité et calcul des KPIs de référence
=============================================================================*/

USE Pizzas;
GO

/*-----------------------------------------------------------------------------
  0. PRÉPARATION ET CONTRÔLE DE LA STRUCTURE DE LA TABLE
-----------------------------------------------------------------------------*/

-- Typage explicite des colonnes monétaires (DECIMAL privilégié à FLOAT en finance)
ALTER TABLE dbo.pizzas_sales
ALTER COLUMN unit_price DECIMAL(10, 2) NOT NULL;

ALTER TABLE dbo.pizzas_sales
ALTER COLUMN total_price DECIMAL(10, 2) NOT NULL;
GO

-- Vérification du dictionnaire des colonnes et des types de données
SELECT 
    COLUMN_NAME                  AS Nom_Colonne,
    DATA_TYPE                    AS Type_Donnee,
    CHARACTER_MAXIMUM_LENGTH     AS Longueur_Max,
    NUMERIC_PRECISION            AS Precision_Numerique,
    NUMERIC_SCALE                AS Decimales,
    IS_NULLABLE                  AS Accepte_NULL
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME   = 'pizzas_sales'
ORDER BY ORDINAL_POSITION;
GO

/*-----------------------------------------------------------------------------
  A. INDICATEURS CLÉS DE PERFORMANCE (KPIs GLOBAUX)
-----------------------------------------------------------------------------*/

-- 1. Chiffre d'affaires total (Total Revenue) -> Attendu : 817 860,05
SELECT 
    CAST(SUM(total_price) AS DECIMAL(12, 2)) AS Total_Revenue
FROM dbo.pizzas_sales;

-- 2. Panier moyen par commande (Average Order Value) -> Attendu : 38,31
SELECT 
    CAST(
        SUM(total_price) / NULLIF(COUNT(DISTINCT order_id), 0) 
        AS DECIMAL(10, 2)
    ) AS Avg_Order_Value
FROM dbo.pizzas_sales;

-- 3. Volume total de pizzas vendues (Total Pizzas Sold) -> Attendu : 49 574
SELECT 
    SUM(quantity) AS Total_Pizzas_Sold
FROM dbo.pizzas_sales;

-- 4. Nombre total de commandes uniques (Total Orders) -> Attendu : 21 350
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM dbo.pizzas_sales;

-- 5. Nombre moyen de pizzas par commande (Average Pizzas Per Order) -> Attendu : 2,32
SELECT 
    CAST(
        CAST(SUM(quantity) AS DECIMAL(10, 2)) 
        / NULLIF(CAST(COUNT(DISTINCT order_id) AS DECIMAL(10, 2)), 0) 
        AS DECIMAL(10, 2)
    ) AS Avg_Pizzas_Per_Order
FROM dbo.pizzas_sales;
GO

/*-----------------------------------------------------------------------------
  B & C. ANALYSES TEMPORELLES DES COMMANDES
-----------------------------------------------------------------------------*/

-- B. Tendance journalière des commandes (Lundi = 1er jour de la semaine)
SET DATEFIRST 1;

SELECT 
    DATEPART(WEEKDAY, order_date) AS day_number,
    DATENAME(WEEKDAY, order_date) AS order_day,
    COUNT(DISTINCT order_id)      AS total_orders
FROM dbo.pizzas_sales
GROUP BY 
    DATEPART(WEEKDAY, order_date),
    DATENAME(WEEKDAY, order_date)
ORDER BY 
    day_number ASC;

-- C. Tendance mensuelle des commandes
SELECT
    YEAR(order_date)              AS order_year,
    MONTH(order_date)             AS month_number,
    DATENAME(MONTH, order_date)   AS order_month,
    COUNT(DISTINCT order_id)      AS total_orders
FROM dbo.pizzas_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY
    order_year ASC,
    month_number ASC;
GO

/*-----------------------------------------------------------------------------
  D, E & F. ANALYSE DE LA PERFORMANCE PAR CATÉGORIE ET PAR TAILLE
-----------------------------------------------------------------------------*/

-- D. Répartition du chiffre d'affaires par catégorie de pizza
SELECT
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(12, 2)) AS total_sales,
    CAST(
        100.0 * SUM(total_price) / NULLIF(SUM(SUM(total_price)) OVER(), 0)
        AS DECIMAL(6, 2)
    ) AS sales_percentage
FROM dbo.pizzas_sales
GROUP BY pizza_category
ORDER BY total_sales DESC;

-- E. Répartition du chiffre d'affaires par taille de pizza
SELECT
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(12, 2)) AS total_sales,
    CAST(
        100.0 * SUM(total_price) / NULLIF(SUM(SUM(total_price)) OVER(), 0)
        AS DECIMAL(6, 2)
    ) AS sales_percentage
FROM dbo.pizzas_sales
GROUP BY pizza_size
ORDER BY total_sales DESC;

-- F. Volume de pizzas vendues par catégorie
SELECT
    pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM dbo.pizzas_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;
GO

/*-----------------------------------------------------------------------------
  G à L. PALMARÈS PRODUITS (TOP 5 & BOTTOM 5)
-----------------------------------------------------------------------------*/

-- G. Top 5 des pizzas par Chiffre d'Affaires
SELECT TOP (5)
    pizza_name,
    CAST(SUM(total_price) AS DECIMAL(12, 2)) AS total_revenue
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_revenue DESC;

-- H. Bottom 5 des pizzas par Chiffre d'Affaires
SELECT TOP (5)
    pizza_name,
    CAST(SUM(total_price) AS DECIMAL(12, 2)) AS total_revenue
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_revenue ASC;

-- I. Top 5 des pizzas par Quantité vendue
SELECT TOP (5)
    pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC;

-- J. Bottom 5 des pizzas par Quantité vendue
SELECT TOP (5)
    pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_pizzas_sold ASC;

-- K. Top 5 des pizzas par Nombre de commandes
SELECT TOP (5)
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_orders DESC;

-- L. Bottom 5 des pizzas par Nombre de commandes
SELECT TOP (5)
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM dbo.pizzas_sales
GROUP BY pizza_name
ORDER BY total_orders ASC;
GO
