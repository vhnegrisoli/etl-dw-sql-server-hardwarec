-- Banco de Dados II - Consultas
-- Projeto: HardwareC - eCommerce
-- Autor: Victor Hugo Negrisoli

/*
* Esta consulta informa quais clientes não fizeram compras no site.
* LEFT JOIN, SUBQUERY
* Operações: LEFT JOIN, SUBQUERY
*/
SELECT c.NOME AS "Nome Clinte", 
	   c.CPF, 
	   c.RG, 
	   c.EMAIL AS "Email Cliente", 
	   c.SENHA AS "Senha Cliente"
FROM T_CLIENTE c 
       LEFT JOIN T_CARRINHODECOMPRA cc ON cc.T_CLIENTE_ID = c.T_CLIENTE_ID
	   WHERE c.T_CLIENTE_ID NOT IN (SELECT a.T_CLIENTE_ID FROM T_CARRINHODECOMPRA a);
	   

/*
* Essa consulta retorna um relatório do total de gasto por todos os clientes
* que compraram no site sem agrupamento. INNER JOIN
* Operações: INNER JOIN
*/
SELECT c.NOME				AS "Nome do Cliente",
	   p.DESCRICAOPRODUTO	AS "Nome do Produto",
       it.QUANTIDADE		AS "Quantidade de Itens",
	   nf.VALORTOTAL		AS "Preço do produto",
	   it.QUANTIDADE *
	   nf.VALORTOTAL		AS "Total gasto"
FROM T_CLIENTE c INNER JOIN T_CARRINHODECOMPRA cc ON c.T_CLIENTE_ID = cc.T_CLIENTE_ID
			     INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = cc.T_CARRINHODECOMPRA_ID
				 INNER JOIN T_PRODUTOS p ON it.T_PRODUTOID = p.T_PRODUTOS_ID
				 INNER JOIN T_ITEMEMISSAONFECLIENTE ne ON ne.FK_CLIENTEID = c.T_CLIENTE_ID
				 INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ne.FK_EMISSAOID
ORDER BY c.NOME;

/*
* Essa consulta retorna um relatório do total de todos os produtos que
* ainda foram comprados. LEFT JOIN, SUBQUERY
* Operações: LEFT JOIN, SUBQUERY
*/
SELECT p.DESCRICAOPRODUTO	AS "Nome do Produto",
       p.PRECOPRODUTO		AS "Preço do Produto",
	   f.RAZAOSOCIAL		AS "Nome do Fornecedor"
FROM   T_PRODUTOS p 		     
	   LEFT JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   LEFT JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
WHERE
	   p.T_PRODUTOS_ID IN (SELECT T_PRODUTOS_ID FROM T_ITEMDOCARRINHO)
ORDER BY p.DESCRICAOPRODUTO;

/*
* Essa consulta retorna um relatório agrupando a quantidade total de itens e o faturamento
* total por cada produto. SUM, ABS, INNER JOIN
* Operações: GROUP BY, SUM, ABS, INNER JOIN
*/

SELECT p.DESCRICAOPRODUTO	AS "Nome do Produto",
	   p.GRUPOPRODUTO		AS "Grupo do Produto",
	   p.CLASSEPRODUTO		AS "Classe do Produto",
	   f.RAZAOSOCIAL		AS "Nome do Fornecedor",
	   SUM(it.QUANTIDADE)   AS "Quantidade",
	   SUM(nf.VALORTOTAL)   AS "Valor total NFe",
	   ABS(SUM(it.QUANTIDADE)
	   *
	   SUM(nf.VALORTOTAL - p.PRECOPRODUTO))
							AS "Faturamento total"
FROM   T_PRODUTOS p 		     
	   INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   INNER JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
	   INNER JOIN T_CARRINHODECOMPRA cm ON it.T_CARRINHODECOMPRA_ID = cm.T_CARRINHODECOMPRA_ID
	   INNER JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CARRINHODECOMPRA_ID 
	   INNER JOIN T_ITEMEMISSAONFECLIENTE ni ON c.T_CLIENTE_ID = ni.FK_CLIENTEID
	   INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ni.FK_EMISSAOID
GROUP BY p.DESCRICAOPRODUTO, p.CLASSEPRODUTO, p.GRUPOPRODUTO, f.RAZAOSOCIAL
ORDER BY p.DESCRICAOPRODUTO;

/*
* Essa consulta retorna a quantidade cadastrada em cada tipo de grupo de produto
* e informa a quantidade vendida e o lucro total da empresa. 
* Operações: GROUP BY, SUM, COUNT, ABS, LEFT JOIN
*/
SELECT p.GRUPOPRODUTO			AS "Grupo do Produto",
	   COUNT(p.T_PRODUTOS_ID)   AS "Quantidade de Produtos",
	   SUM(it.QUANTIDADE)       AS "Quantidade",
	   ABS(SUM(it.QUANTIDADE)
	   *
	   SUM(nf.VALORTOTAL - p.PRECOPRODUTO))
								AS "Faturamento total"
FROM   T_PRODUTOS p 		     
	   LEFT JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   LEFT JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
	   LEFT JOIN T_CARRINHODECOMPRA cm ON it.T_CARRINHODECOMPRA_ID = cm.T_CARRINHODECOMPRA_ID
	   LEFT JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CARRINHODECOMPRA_ID 
	   LEFT JOIN T_ITEMEMISSAONFECLIENTE ni ON c.T_CLIENTE_ID = ni.FK_CLIENTEID
	   LEFT JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ni.FK_EMISSAOID
GROUP BY p.GRUPOPRODUTO
ORDER BY p.GRUPOPRODUTO;

/*
*	Essa consulta retorna um relatório da quantidade de compras
*   dos clientes de Londrina ou do Rio de Janeiro.
*   Operações: GROUP BY, SUM, UNION
*/
SELECT c.CIDADE				AS "Cidade do Cliente",
	   c.NOME				AS "Nome do Cliente",
       SUM(it.QUANTIDADE)	AS "Quantidade de Itens",
	   SUM(it.QUANTIDADE *
	   nf.VALORTOTAL)		AS "Total gasto"
FROM T_CLIENTE c INNER JOIN T_CARRINHODECOMPRA cc ON c.T_CLIENTE_ID = cc.T_CLIENTE_ID
			     INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = cc.T_CARRINHODECOMPRA_ID
				 INNER JOIN T_PRODUTOS p ON it.T_PRODUTOID = p.T_PRODUTOS_ID
				 INNER JOIN T_ITEMEMISSAONFECLIENTE ne ON ne.FK_CLIENTEID = c.T_CLIENTE_ID
				 INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ne.FK_EMISSAOID
WHERE c.CIDADE = 'Londrina'
GROUP BY c.CIDADE, c.NOME

UNION
 
SELECT c.CIDADE				AS "Cidade do Cliente",
	   c.NOME				AS "Nome do Cliente",
       SUM(it.QUANTIDADE)	AS "Quantidade de Itens",
	   SUM(it.QUANTIDADE *
	   nf.VALORTOTAL)		AS "Total gasto"
FROM T_CLIENTE c INNER JOIN T_CARRINHODECOMPRA cc ON c.T_CLIENTE_ID = cc.T_CLIENTE_ID
			     INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = cc.T_CARRINHODECOMPRA_ID
				 INNER JOIN T_PRODUTOS p ON it.T_PRODUTOID = p.T_PRODUTOS_ID
				 INNER JOIN T_ITEMEMISSAONFECLIENTE ne ON ne.FK_CLIENTEID = c.T_CLIENTE_ID
				 INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ne.FK_EMISSAOID
WHERE c.CIDADE = 'Rio de Janeiro'
GROUP BY c.CIDADE, c.NOME
ORDER BY c.CIDADE;

/*
* Essa consulta retorna uma interseção entre a primeira consulta que
* exibe um relatório contendo apenas os produtos que possuem mais
* de uma compra registrada e a segunda consulta que retorna apenas
* os itens que possuem valores totais de notas fiscais diferentes de nulo.
* Operações: GROUP BY, SUM, INTERSECT, COUNT, ABS
*/
SELECT p.GRUPOPRODUTO		AS "Grupo do Produto",
	   p.DESCRICAOPRODUTO	AS "Nome do Produto",
	   f.RAZAOSOCIAL		AS "Nome do Fornecedor",
	   SUM(it.QUANTIDADE)   AS "Quantidade",
	   SUM(nf.VALORTOTAL)   AS "Valor total NFe",
	   ABS(SUM(it.QUANTIDADE)
	   *
	   SUM(nf.VALORTOTAL - p.PRECOPRODUTO))
							AS "Faturamento total"
FROM   T_PRODUTOS p 		     
	   LEFT JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   LEFT JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
	   LEFT JOIN T_CARRINHODECOMPRA cm ON it.T_CARRINHODECOMPRA_ID = cm.T_CARRINHODECOMPRA_ID
	   LEFT JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CARRINHODECOMPRA_ID 
	   LEFT JOIN T_ITEMEMISSAONFECLIENTE ni ON c.T_CLIENTE_ID = ni.FK_CLIENTEID
	   LEFT JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ni.FK_EMISSAOID
GROUP BY p.DESCRICAOPRODUTO, p.CLASSEPRODUTO, p.GRUPOPRODUTO, f.RAZAOSOCIAL
HAVING SUM(it.QUANTIDADE) > 0

INTERSECT 

SELECT p.GRUPOPRODUTO		AS "Grupo do Produto",
	   p.DESCRICAOPRODUTO	AS "Nome do Produto",
	   f.RAZAOSOCIAL		AS "Nome do Fornecedor",
	   SUM(it.QUANTIDADE)   AS "Quantidade",
	   SUM(nf.VALORTOTAL)   AS "Valor total NFe",
	   ABS(SUM(it.QUANTIDADE)
	   *
	   SUM(nf.VALORTOTAL - p.PRECOPRODUTO))
							AS "Faturamento total"
FROM   T_PRODUTOS p 		     
	   LEFT JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   LEFT JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
	   LEFT JOIN T_CARRINHODECOMPRA cm ON it.T_CARRINHODECOMPRA_ID = cm.T_CARRINHODECOMPRA_ID
	   LEFT JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CARRINHODECOMPRA_ID 
	   LEFT JOIN T_ITEMEMISSAONFECLIENTE ni ON c.T_CLIENTE_ID = ni.FK_CLIENTEID
	   LEFT JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ni.FK_EMISSAOID
GROUP BY p.DESCRICAOPRODUTO, p.CLASSEPRODUTO, p.GRUPOPRODUTO, f.RAZAOSOCIAL
HAVING SUM(nf.VALORTOTAL) > 0;

/*
*  Retorna apenas os clientes que moram na mesma cidade dos fornecedores
*  dos produtos da loja e que possuem compras registradas.
*  Operações: SUBQUERY, LEFT JOIN
*/

SELECT c.NOME				AS "Nome do Cliente",
	   p.DESCRICAOPRODUTO	AS "Nome do Produto",
       it.QUANTIDADE		AS "Quantidade de Itens",
	   nf.VALORTOTAL		AS "Preço do produto",
	   it.QUANTIDADE *
	   nf.VALORTOTAL		AS "Total gasto"
FROM T_CLIENTE c LEFT JOIN T_CARRINHODECOMPRA cc ON c.T_CLIENTE_ID = cc.T_CLIENTE_ID
			     LEFT JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = cc.T_CARRINHODECOMPRA_ID
				 LEFT JOIN T_PRODUTOS p ON it.T_PRODUTOID = p.T_PRODUTOS_ID
				 LEFT JOIN T_ITEMEMISSAONFECLIENTE ne ON ne.FK_CLIENTEID = c.T_CLIENTE_ID
				 LEFT JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ne.FK_EMISSAOID
				 LEFT JOIN T_FORNECEDOR f ON p.T_FORNECEDOR_ID = f.T_FORNECEDOR_ID
WHERE c.CIDADE IN (SELECT f.MUNICIPIO FROM T_FORNECEDOR f)
	  AND p.CLASSEPRODUTO NOT IN (SELECT CLASSEPRODUTO 
	                              FROM T_PRODUTOS
	                              WHERE T_PRODUTOID NOT IN (
										SELECT T_PRODUTOID 
										FROM T_ITEMDOCARRINHO))
ORDER BY c.NOME;

/*
*  Retorna apenas os valores dos produtos mais caros comprados por cada cliente.
*  Operações: INNER JOIN, MAX
*/

SELECT c.NOME					AS "Nome do Cliente",
       MAX(nf.VALORTOTAL)		AS "Preço do produto",
	   MAX(it.QUANTIDADE *
	   nf.VALORTOTAL)			AS "Total gasto"
FROM T_CLIENTE c INNER JOIN T_CARRINHODECOMPRA cc ON c.T_CLIENTE_ID = cc.T_CLIENTE_ID
			     INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = cc.T_CARRINHODECOMPRA_ID
				 INNER JOIN T_PRODUTOS p ON it.T_PRODUTOID = p.T_PRODUTOS_ID
				 INNER JOIN T_ITEMEMISSAONFECLIENTE ne ON ne.FK_CLIENTEID = c.T_CLIENTE_ID
				 INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ne.FK_EMISSAOID
				 INNER JOIN T_FORNECEDOR f ON p.T_FORNECEDOR_ID = f.T_FORNECEDOR_ID
GROUP BY c.NOME
ORDER BY c.NOME;

/*
*  Retorna apenas os produtos com os menores valores registrados nas notas fiscais
*  Operações: INNER JOIN, MIN
*/

SELECT p.DESCRICAOPRODUTO	AS "Nome do Produto",
	   p.GRUPOPRODUTO		AS "Grupo do Produto",
	   p.CLASSEPRODUTO		AS "Classe do Produto",
	   f.RAZAOSOCIAL		AS "Nome do Fornecedor",
	   MIN(nf.VALORTOTAL)   AS "Valor total NFe"
FROM   T_PRODUTOS p 		     
	   INNER JOIN T_ITEMDOCARRINHO it ON it.T_CARRINHODECOMPRA_ID = p.T_PRODUTOS_ID
	   INNER JOIN T_FORNECEDOR f ON f.T_FORNECEDOR_ID = p.T_FORNECEDOR_ID
	   INNER JOIN T_CARRINHODECOMPRA cm ON it.T_CARRINHODECOMPRA_ID = cm.T_CARRINHODECOMPRA_ID
	   INNER JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CARRINHODECOMPRA_ID 
	   INNER JOIN T_ITEMEMISSAONFECLIENTE ni ON c.T_CLIENTE_ID = ni.FK_CLIENTEID
	   INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = ni.FK_EMISSAOID
GROUP BY p.DESCRICAOPRODUTO, p.CLASSEPRODUTO, p.GRUPOPRODUTO, f.RAZAOSOCIAL
ORDER BY p.DESCRICAOPRODUTO;


/*
* Esta consulta retorna um relatório de todos os funcionários que concretizaram vendas.
* Retorna o nome dos funcionários, a quantidade de compras realizadas por cada 
* funcionário, o lucro total obtido por cada funcionário e a média do lucro por cada
* venda efetuada.
*/

SELECT 
	fc.NOMEFUNCIONARIO								AS "Nome do Funcionário",
	COUNT(fc.T_FUNCIONARIO_ID)								AS "Quantidade",
	(SUM(it.QUANTIDADE) *
	SUM(nf.VALORTOTAL - p.PRECOPRODUTO))			AS "Lucro",
	CAST(AVG(it.QUANTIDADE) *
	(SUM(nf.VALORTOTAL - p.PRECOPRODUTO))/
	COUNT(fc.T_FUNCIONARIO_ID) AS NUMERIC(10,2))			AS "Média por produto"
FROM T_FUNCIONARIO fc 
	INNER JOIN T_PRODUTOS p ON p.T_FUNCIONARIO_ID = fc.T_FUNCIONARIO_ID
	INNER JOIN T_ITEMDOCARRINHO it ON it.T_PRODUTOID = fc.T_FUNCIONARIO_ID
	INNER JOIN T_CARRINHODECOMPRA cm ON cm.T_CARRINHODECOMPRA_ID = it.T_CARRINHODECOMPRA_ID
	INNER JOIN T_CLIENTE c ON c.T_CLIENTE_ID = cm.T_CLIENTE_ID
	INNER JOIN T_ITEMEMISSAONFECLIENTE em ON em.FK_CLIENTEID = c.T_CLIENTE_ID
	INNER JOIN T_EMISSAONFE nf ON nf.T_EMISSAONFE_ID = em.FK_EMISSAOID
	GROUP BY fc.NOMEFUNCIONARIO
	HAVING (SUM(it.QUANTIDADE) *
	SUM(nf.VALORTOTAL - p.PRECOPRODUTO)) >= 0;