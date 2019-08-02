-- Triggers
CREATE TABLE ATUALIZACAO_CLIENTE_LOG(
	NOME			VARCHAR(120),
	CPF				NUMERIC(11,0),
	RG				NUMERIC(11,0),
	DATA_STATUS		DATETIME,
	OPERACAO		VARCHAR(60)
);

SELECT * FROM T_CLIENTE;

-- ======================================================================================================
/*
*  Trigger para inserção
*/
CREATE TRIGGER T_INSERT_CLIENTE
ON T_CLIENTE
AFTER INSERT, UPDATE, DELETE
AS
DECLARE @NOME VARCHAR(120)
DECLARE @CPF NUMERIC(11,0)
DECLARE @RG  NUMERIC(11,0)
SELECT @NOME = i.NOME FROM INSERTED i
SELECT @CPF = i.CPF FROM INSERTED i
SELECT @RG = i.RG FROM INSERTED i
IF @NOME IS NOT NULL
BEGIN
    INSERT INTO ATUALIZACAO_CLIENTE_LOG VALUES (@NOME, @CPF, @RG, SYSDATETIME(), 'Inserido')
END
GO
-- ======================================================================================================

/*
*  Trigger para atualização
*/

CREATE TRIGGER T_UPDATE_CLIENTE
ON T_CLIENTE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    INSERT INTO ATUALIZACAO_CLIENTE_LOG (NOME, CPF, RG, DATA_STATUS, OPERACAO)
	SELECT i.NOME, i.CPF, i.RG, SYSDATETIME(), 'Novo' FROM INSERTED i
	UNION
	SELECT d.NOME, d.CPF, d.RG, SYSDATETIME(), 'Antigo' FROM DELETED d
END
GO

-- ======================================================================================================
/*
*  Trigger para remoção
*/

CREATE TRIGGER T_DELETE_CLIENTE
ON T_CLIENTE
AFTER INSERT, UPDATE, DELETE
AS
DECLARE @NOME VARCHAR(120)
DECLARE @CPF NUMERIC(11,0)
DECLARE @RG  NUMERIC(11,0)
SELECT @NOME = i.NOME FROM DELETED i
SELECT @CPF = i.CPF FROM DELETED i
SELECT @RG = i.RG FROM DELETED i
IF @NOME IS NOT NULL
BEGIN
    INSERT INTO ATUALIZACAO_CLIENTE_LOG VALUES (@NOME, @CPF, @RG, SYSDATETIME(), 'Removido')
END
GO
-- ======================================================================================================

SELECT * FROM ATUALIZACAO_CLIENTE_LOG;
