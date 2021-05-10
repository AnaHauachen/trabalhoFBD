# trabalhoFBD

Name DB: TBD_TRAB1

Tables:
	- Factura
	- FactLinha
	- LogOperations


Description Tables:
	
	- Description Factura:
		-- Columns:
			--- FacturaID int NOT NULL (FacturaID >= 1) (Identificação da fatura com inteiros).
			--- ClienteID int NOT NULL (ClienteID >= 1) (Identificação do cliente com inteiros).
			--- Nome nvarchar(50) NOT NULL (Nome cliente em caracteres até tamanho 50).
			--- Morada nvarchar(30) NOT NULL (Morada cliente em caracteres até tamanho 30).

		-- Primary keys: FacturaID
		-- Foreign keys: None

		-- Notes: Tabela contendo todas as faturas e os respectivos clientes e informação do cliente na fatura.


	- Description FactLinha:
		-- Columns:
			--- FacturaID int NOT NULL (Identificação da fatura com o ID da tabela Fatura).
			--- ProdutoID int NOT NULL (Identificação do produto com inteiros).
			--- Designação nvarchar(50) NOT NULL (Designação do Produto em caracteres até tamanho 50).
			--- Preco decimal(10,2) NOT NULL DEFAULT 10.0 (Preco >= 0.0) (Preco do produto até 9999999999.99).
			--- Qtd decimal(10,2) NOT NULL DEFAULT 1.0 (Qtd >= 0.0) (Quantidade do produto até 9999999999.99).

		-- Primary keys: FacturaID, ProdutoID
		-- Foreign keys: FacturaID (Tabela Factura)

		--Notes: Tabela contendo todas as informações sobre as faturas linha a linha, todos os produtos de qualquer compra são redirecionados para esta tabela identificados pelo número da fatura e próprio produto.


	- Description LogOperations:
		-- Columns:
			--- NumReg int IDENTITY(1,1) (Identificação do registo com inteiros incrementando automáticamente).
			--- EventType char(1) (Designação do tipo do evento com um caractér: I, U, D (Insert, Update, Delete)).

			--- Objecto varchar(30) (Designação do Objeto afetado em caracteres até tamanho 30).
			--- Valor varchar(100) (Valor modificado em caracteres até tamanho 100).
			--- Referencia varchar(100) (Identificação da tabela em caracteres até tamanho 100).

			--- UserID nvarchar(30) NOT NULL DEFAULT USER_NAME() (Campo de preenchimento automático, apenas vai buscar a info do utilizador que está a mexer na bd).
			--- TerminalD nvarchar(30) NOT NULL DEFAULT HOST_ID() (Campo de preenchimento automático, apenas vai buscar a info do utilizador que está a mexer na bd). 
			--- TerminalName nvarchar(30) NOT NULL DEFAULT HOST_NAME() (Campo de preenchimento automático, apenas vai buscar a info do utilizador que está a mexer na bd).
			--- DCriação NOT NULLT DEFAULT GetDate() (Data de criação).

		-- Primary keys: NumeReg

		-- Foreign keys: None

		-- Notes: Tabela onde fica armazenado qualquer tipo de ação feita sobre as tabelas desta base de dados.
