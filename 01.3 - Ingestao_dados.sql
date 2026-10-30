--------------------------------
----------- INGESTÃO -----------
--------------------------------

-- Stage: Local onde os arquivos ficam disponíveis para carregamento
-- File Format: Define como o Snowflake deve interpretar o CSV
-- COPY INTO: Carrega os registros do arquivo para uma tabela


---------------------------------------------------
----------- CRIANDO STAGE E FILE FORMAT -----------
---------------------------------------------------

USE DATABASE SALES_ANALYTICS;
USE SCHEMA BRONZE;
USE WAREHOUSE WH_ENG;

-- CRIAR FORMATO PARA ARQUIVOS CSV
CREATE FILE FORMAT IF NOT EXISTS FF_CSV
    TYPE = CSV 
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    EMPTY_FIELD_AS_NULL = TRUE 
    COMPRESSION = AUTO;

-- CRIAR STAGE INTERNA
CREATE STAGE IF NOT EXISTS STG_SALES_CSV
    FILE_FORMAT = FF_CSV;

-- VALIDANDO OBJETOS 
SHOW FILE FORMATS IN SCHEMA SALES_ANALYTICS.BRONZE;

SHOW STAGES IN SCHEMA SALES_ANALYTICS.BRONZE;


---------------------------------------
----------- CRIANDO TABELAS -----------
---------------------------------------

USE DATABASE SALES_ANALYTICS;
USE SCHEMA BRONZE;
USE WAREHOUSE WH_ENG;

-- 1. Clientes
CREATE TABLE IF NOT EXISTS CLIENTES (
    ID VARCHAR,
    NOME VARCHAR,
    EMAIL VARCHAR,
    TELEFONE VARCHAR,
    DATA_REGISTRO VARCHAR
);

-- 2. Categorias
CREATE TABLE IF NOT EXISTS CATEGORIAS (
    ID VARCHAR,
    NOME VARCHAR
);

-- 3. Produtos
CREATE TABLE IF NOT EXISTS PRODUTOS (
    ID VARCHAR,
    NOME VARCHAR,
    DESCRICAO VARCHAR,
    CATEGORIA_ID VARCHAR,
    PRECO VARCHAR,
    MARCA VARCHAR,
    ESTOQUE VARCHAR,
    DATA_CADASTRO VARCHAR
);

-- 4. Pedidos
CREATE TABLE IF NOT EXISTS PEDIDOS (
    ID VARCHAR,
    CLIENTE_ID VARCHAR,
    ENDERECO_ID VARCHAR,
    DATA_PEDIDO VARCHAR,
    STATUS VARCHAR
);

-- 5. Itens dos pedidos
CREATE TABLE IF NOT EXISTS ITENS_PEDIDOS (
    PEDIDO_ID VARCHAR,
    PRODUTO_ID VARCHAR,
    QUANTIDADE VARCHAR,
    PRECO_UNITARIO VARCHAR,
    SUBTOTAL VARCHAR
);

-- 6. Pagamentos
CREATE TABLE IF NOT EXISTS PAGAMENTOS (
    ID VARCHAR,
    PEDIDO_ID VARCHAR,
    VALOR VARCHAR,
    METODO VARCHAR,
    STATUS VARCHAR,
    DATA_PAGAMENTO VARCHAR
);

-- 7. Carrinho
CREATE TABLE IF NOT EXISTS CARRINHO (
    CLIENTE_ID VARCHAR,
    PRODUTO_ID VARCHAR,
    QUANTIDADE VARCHAR,
    DATA_ADICIONADO VARCHAR
);

-- 8. Avaliações
CREATE TABLE IF NOT EXISTS AVALIACOES (
    CLIENTE_ID VARCHAR,
    PRODUTO_ID VARCHAR,
    NOTA VARCHAR,
    COMENTARIO VARCHAR,
    DATA_AVALIACAO VARCHAR
);

-- VALIDANDO 

SHOW TABLES IN SCHEMA SALES_ANALYTICS.BRONZE;

SALES_ANALYTICS.BRONZE.STG_SALES_CSV

LIST @SALES_ANALYTICS.BRONZE.STG_SALES_CSV;


-----------------------------------------------------------------
----------- Aula 02.6 — Carregando os dados na Bronze -----------
-----------------------------------------------------------------

-- VALIDAR ANTES DA CARGA
SELECT 
    $1 AS ID,
    $2 AS NOME
FROM @SALES_ANALYTICS.BRONZE.STG_SALES_CSV/categorias.csv
    (FILE_FORMAT => 'SALES_ANALYTICS.BRONZE.FF_CSV');

--------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV CATEGORIAS -----------
--------------------------------------------------------------

-- EXECUTAR COPY
COPY INTO SALES_ANALYTICS.BRONZE.CATEGORIAS
FROM @SALES_ANALYTICS.BRONZE.STG_SALES_CSV/categorias.csv
FILE_FORMAT = (
    FORMAT_NAME = 'SALES_ANALYTICS.BRONZE.FF_CSV'
)
ON_ERROR = 'ABORT_STATEMENT';

-- VALIDAR 
SELECT *
FROM SALES_ANALYTICS.BRONZE.CATEGORIAS;

SELECT COUNT(*) AS TOTAL_REGISTROS
FROM SALES_ANALYTICS.BRONZE.CATEGORIAS;

-- CONSULTAR HISTORICO DA CARGA
SELECT *
FROM TABLE(
    SALES_ANALYTICS.INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'SALES_ANALYTICS.BRONZE.CATEGORIAS',
        START_TIME => DATEADD('HOUR', -1, CURRENT_TIMESTAMP())
    )
);


USE DATABASE SALES_ANALYTICS;
USE SCHEMA BRONZE;
USE WAREHOUSE WH_ENG;

------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV CLIENTES -----------
------------------------------------------------------------
COPY INTO BRONZE.CLIENTES
FROM @BRONZE.STG_SALES_CSV/clientes.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';


------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV PRODUTOS -----------
------------------------------------------------------------
COPY INTO BRONZE.PRODUTOS
FROM @BRONZE.STG_SALES_CSV/produtos.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';

------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV PEDIDOS ------------
------------------------------------------------------------
COPY INTO BRONZE.PEDIDOS
FROM @BRONZE.STG_SALES_CSV/pedidos.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';

-----------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV ITENS_PEDIDOS -----------
-----------------------------------------------------------------
COPY INTO BRONZE.ITENS_PEDIDOS
FROM @BRONZE.STG_SALES_CSV/itens_pedidos.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';

--------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV PAGAMENTOS -----------
--------------------------------------------------------------
COPY INTO BRONZE.PAGAMENTOS
FROM @BRONZE.STG_SALES_CSV/pagamentos.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';


--------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV CARRINHO -------------
--------------------------------------------------------------
COPY INTO BRONZE.CARRINHO
FROM @BRONZE.STG_SALES_CSV/carrinho.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';

--------------------------------------------------------------
----------- CARREGAR PARA STG_SALES_CSV AVALIAÇÕES -----------
--------------------------------------------------------------
COPY INTO BRONZE.AVALIACOES
FROM @BRONZE.STG_SALES_CSV/avaliacoes.csv
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
ON_ERROR = 'ABORT_STATEMENT';


-- VALIDAR TODAS AS TABELAS 
SELECT 'CLIENTES' AS TABELA, COUNT(*) AS TOTAL
FROM BRONZE.CLIENTES

UNION ALL

SELECT 'CATEGORIAS', COUNT(*)
FROM BRONZE.CATEGORIAS

UNION ALL

SELECT 'PRODUTOS', COUNT(*)
FROM BRONZE.PRODUTOS

UNION ALL

SELECT 'PEDIDOS', COUNT(*)
FROM BRONZE.PEDIDOS

UNION ALL

SELECT 'ITENS_PEDIDOS', COUNT(*)
FROM BRONZE.ITENS_PEDIDOS

UNION ALL

SELECT 'PAGAMENTOS', COUNT(*)
FROM BRONZE.PAGAMENTOS

UNION ALL

SELECT 'CARRINHO', COUNT(*)
FROM BRONZE.CARRINHO

UNION ALL

SELECT 'AVALIACOES', COUNT(*)
FROM BRONZE.AVALIACOES

ORDER BY TABELA;

LIST @SALES_ANALYTICS.BRONZE.STG_SALES_CSV;

---------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA AVALIAÇÕES -----------
---------------------------------------------------------------------------

COPY INTO SALES_ANALYTICS.BRONZE.CLIENTES
FROM @SALES_ANALYTICS.BRONZE.STG_SALES_CSV
FILE_FORMAT = (
    FORMAT_NAME = 'SALES_ANALYTICS.BRONZE.FF_CSV'
)
PATTERN = '.*clientes[.]csv'
ON_ERROR = 'ABORT_STATEMENT';


---------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA PRODUTOS  ------------
---------------------------------------------------------------------------
COPY INTO BRONZE.PRODUTOS
FROM @BRONZE.STG_SALES_CSV
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
PATTERN = '.*produtos[.]csv';

---------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA PEDIDOS  -------------
---------------------------------------------------------------------------
COPY INTO SALES_ANALYTICS.BRONZE.PEDIDOS
FROM @SALES_ANALYTICS.BRONZE.STG_SALES_CSV
FILE_FORMAT = (
    FORMAT_NAME = 'SALES_ANALYTICS.BRONZE.FF_CSV'
)
PATTERN = '(^|.*/)pedidos[.]csv'
ON_ERROR = 'ABORT_STATEMENT';

---------------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA ITENS_PEDIDOS  -------------
---------------------------------------------------------------------------------
COPY INTO BRONZE.ITENS_PEDIDOS
FROM @BRONZE.STG_SALES_CSV
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
PATTERN = '.*itens_pedidos[.]csv';

---------------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA PAGAMENTOS  ----------------
---------------------------------------------------------------------------------
COPY INTO BRONZE.PAGAMENTOS
FROM @BRONZE.STG_SALES_CSV
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
PATTERN = '.*pagamentos[.]csv';

---------------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA CARRINHO -------------------
---------------------------------------------------------------------------------
COPY INTO BRONZE.CARRINHO
FROM @BRONZE.STG_SALES_CSV
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
PATTERN = '.*carrinho[.]csv';

-----------------------------------------------------------------------------------
----------- CARREGAR da STG_SALES_CSV -> PARA TABELA AVALIACOES -------------------
-----------------------------------------------------------------------------------
COPY INTO BRONZE.AVALIACOES
FROM @BRONZE.STG_SALES_CSV
FILE_FORMAT = (FORMAT_NAME = 'BRONZE.FF_CSV')
PATTERN = '.*avaliacoes[.]csv';


-- VALIDANDO
SELECT 'CLIENTES' AS TABELA, COUNT(*) AS TOTAL FROM BRONZE.CLIENTES
UNION ALL
SELECT 'CATEGORIAS', COUNT(*) FROM BRONZE.CATEGORIAS
UNION ALL
SELECT 'PRODUTOS', COUNT(*) FROM BRONZE.PRODUTOS
UNION ALL
SELECT 'PEDIDOS', COUNT(*) FROM BRONZE.PEDIDOS
UNION ALL
SELECT 'ITENS_PEDIDOS', COUNT(*) FROM BRONZE.ITENS_PEDIDOS
UNION ALL
SELECT 'PAGAMENTOS', COUNT(*) FROM BRONZE.PAGAMENTOS
UNION ALL
SELECT 'CARRINHO', COUNT(*) FROM BRONZE.CARRINHO
UNION ALL
SELECT 'AVALIACOES', COUNT(*) FROM BRONZE.AVALIACOES
ORDER BY TABELA;

