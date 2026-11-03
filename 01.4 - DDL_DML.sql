-----------------------------------------
----------- DDL E DML -------------------
-----------------------------------------

USE DATABASE SALES_ANALYTICS;
USE SCHEMA SILVER;
USE WAREHOUSE WH_ENG;

-- Vamos criar uma tabela de testes para não alterar os dados da Bronze.
-- TIMESTAMP_NTZ: data e hora sem fuso horário associado.
-- DEFAULT: valor utilizado quando não informado explicitamente.

CREATE OR REPLACE TABLE TESTE_CLIENTES(
    ID NUMBER(10,0),
    NOME VARCHAR(100),
    EMAIL VARCHAR(150),
    ATIVO BOOLEAN DEFAULT TRUE,
    DATA_CRIACAO TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- 2. INSERT INTO

INSERT INTO TESTE_CLIENTES(ID, NOME, EMAIL)
VALUES
    (1, 'Ana Silva', 'ana@email.com'),
    (2, 'Carlos Souza', 'carlos@email.com'),
    (3, 'Mariana Lima', 'mariana@email.com');


SELECT * 
FROM SALES_ANALYTICS.SILVER.TESTE_CLIENTES;

-- 3. UPDATE
UPDATE TESTE_CLIENTES
SET ATIVO = FALSE
WHERE ID = 2;

-- 4. DELETE
DELETE FROM TESTE_CLIENTES
WHERE ID = 3;

-- 5. ALTER TABLE
ALTER TABLE TESTE_CLIENTES
ADD COLUMN TELEFONE VARCHAR(20);

-- 6. TRUNCATE vs DELETE vs DROP
-- DELETE - Remove linhas, podendo utilizar WHERE
-- TRUNCATE - Remove todas as linhas, mantendo a estrutura
-- DROP - Remove o objeto da base de dados

DESCRIBE TABLE SALES_ANALYTICS.SILVER.TESTE_CLIENTES;

-- Aula 03.2 — Conversão de tipos
-- CAST vs TRY_CAST

-- O CAST converte um valor para outro tipo. Porém, se encontrar uma string incompatível, poderá gerar erro.

SELECT 
    ID,
    CAST(ID AS NUMBER) AS ID_NUMERICO
FROM SALES_ANALYTICS.BRONZE.CLIENTES;


-- Já o TRY_CAST retorna NULL quando não consegue converter uma string
SELECT
    ID,
    TRY_CAST(ID AS NUMBER) AS ID_NUMERICO
FROM SALES_ANALYTICS.BRONZE.CLIENTES;

-- EX:
SELECT 
    TRY_TO_NUMBER('150') AS VALOR_VALIDO,
    TRY_TO_NUMBER('ABC') AS VALOR_INVALIDO;

-- TRY_TO_DATE
SELECT 
    DATA_REGISTRO,
    TRY_TO_DATE(DATA_REGISTRO, 'YYYY-MM-DD') AS DATA_CONVERTIDA
FROM SALES_ANALYTICS.BRONZE.CLIENTES
LIMIT 10;

-- Identificando valores inválidos
SELECT *
FROM SALES_ANALYTICS.BRONZE.CLIENTES
WHERE TRY_TO_NUMBER(ID) IS NULL
  AND ID IS NOT NULL;

-- Exercícios 01 — DDL, DML e conversão
-- 1. Criar uma tabela
-- Crie uma tabela SILVER.TESTE_PRODUTOS com ID numérico, NOME texto, PRECO decimal com duas casas e ESTOQUE inteiro.
USE DATABASE SALES_ANALYTICS;
USE SCHEMA SILVER;
USE WAREHOUSE WH_ENG;

CREATE OR REPLACE TABLE TESTE_PRODUTOS(
    ID NUMBER(10,0),
    NOME VARCHAR(100),
    PRECO NUMBER(10,2),
    ESTOQUE INTEGER
);

-- 2. Inserir registros
-- Insira três produtos fictícios utilizando um único INSERT INTO.
INSERT INTO TESTE_PRODUTOS(ID, NOME, PRECO, ESTOQUE)
VALUES
    (1, 'Machado',250.10,500),
    (2, 'Martelo',150.00,200),
    (3, 'Macaneta',70.80,100),
    (4, 'Prego',25,500);
    
-- 3. Atualizar registros
-- Aumente em 10% o preço dos produtos com estoque maior que 20.
UPDATE SALES_ANALYTICS.SILVER.TESTE_PRODUTOS
SET PRECO = PRECO *1.10
WHERE ESTOQUE > 20;

SELECT * FROM SALES_ANALYTICS.SILVER.TESTE_PRODUTOS;

-- 4. Excluir registros
-- Exclua os produtos cujo estoque seja igual a zero.

-- DELETE - Remove linhas, podendo utilizar WHERE
-- TRUNCATE - Remove todas as linhas, mantendo a estrutura
-- DROP - Remove o objeto da base de dados

DELETE FROM SALES_ANALYTICS.SILVER.TESTE_PRODUTOS
WHERE ESTOQUE = 0

-- 5. Converter valores
-- Consulte BRONZE.PRODUTOS e converta PRECO para NUMBER(12,2) e ESTOQUE para NUMBER(10,0), utilizando funções TRY.

SELECT
    TRY_CAST(TO_VARCHAR(PRECO) AS NUMBER(12,2)) AS NOVO_PRECO,
    TRY_CAST(TO_VARCHAR(ESTOQUE) AS NUMBER(10,0)) AS NOVO_ESTOQUE
FROM SALES_ANALYTICS.SILVER.TESTE_PRODUTOS;


-- 6. Identificar erros
-- Encontre os produtos cujo PRECO não seja NULL, mas não possa ser convertido para número.

SELECT 
    NOME
FROM SALES_ANALYTICS.SILVER.TESTE_PRODUTOS
WHERE PRECO IS NOT NULL;


