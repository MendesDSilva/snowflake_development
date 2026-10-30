------------------------------------------------
----------- CRIAR DATABASE E SCHEMAS -----------
------------------------------------------------

USE WAREHOUSE WH_ENG;

CREATE DATABASE IF NOT EXISTS SALES_ANALYTICS;

USE DATABASE SALES_ANALYTICS;

CREATE SCHEMA IF NOT EXISTS BRONZE;
CREATE SCHEMA IF NOT EXISTS SILVER;
CREATE SCHEMA IF NOT EXISTS GOLD;

-- VALIDAR
SHOW WAREHOUSES;
SHOW DATABASES;
SHOW SCHEMAS IN DATABASE SALES_ANALYTICS;


-- Exercicio 01 — Verificação do ambiente
SELECT 
    CURRENT_DATABASE() AS database_atual,
    CURRENT_WAREHOUSE() AS warehouse_atual,
    CURRENT_ROLE() AS role_atual;
