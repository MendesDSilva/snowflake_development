--------------------------------------------
----------- IDENTIFICAR AMBIENTE -----------
--------------------------------------------
-- Warehouse: Recursos computacionais para executar o sql
-- Database: Agrupa schemas 
-- Schema: Organiza as tabelas, views e outros objetos 
-- Table: Armazena registros 
-- Stage: Local para disponibilizar arquivos para ingestão
-- Role: Controla permissões de acesso 


SELECT 
    CURRENT_USER() AS usuario,ambient
    CURRENT_ROLE() AS role_atual,
    CURRENT_WAREHOUSE() AS warehouse_atual,
    CURRENT_DATABASE() AS database_atual,
    CURRENT_SCHEMA() AS schema_atual;


----------------------------------------
----------- CRIAR O AMBIENTE -----------
----------------------------------------
-- XSMALL: menor tamanho padrão de warehouse.
-- AUTO_SUSPEND = 60: suspende após 60 segundos de inatividade.
-- AUTO_RESUME = TRUE: reinicia automaticamente quando necessário.
-- INITIALLY_SUSPENDED = TRUE: cria inicialmente suspenso.

CREATE WAREHOUSE IF NOT EXISTS WH_ENG
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;
