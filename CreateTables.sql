USE master

DECLARE @DBName sysname
DECLARE @DataPath nvarchar(200)
DECLARE @DataFileName nvarchar(200)
DECLARE @LogPath nvarchar(200)
DECLARE @LogFileName nvarchar(200)

-- Nome e caminho para a BD
SET @DBName = 'TBD_TRAB1'
SET @DataPath = 'c:\MEI_TBD\' + @DBName   -- Alterar se necess�rio
SET @LogPath  = 'c:\MEI_TBD\' + @DBName   -- Alterar se necess�rio

-- Nome dos ficheiros de dados e log
SET @DataFileName = @DataPath +'\Trab1dat.mdf' 
SET @LogFileName  = @LogPath  +'\Trab1log.ldf' 

-- Criar as directorias (pastas)
SET NOCOUNT ON;
DECLARE @DirectoryExists int;

EXEC master.dbo.xp_fileexist @DataPath, @DirectoryExists OUT;
IF @DirectoryExists = 0
   EXEC master.sys.xp_create_subdir @DataPath;

EXEC master.dbo.xp_fileexist @LogPath, @DirectoryExists OUT;
IF @DirectoryExists = 0
   EXEC master.sys.xp_create_subdir @LogPath;
   

-- Criar a Base de dados
   
DECLARE @SQLString nvarchar(max)

SET @SQLString = 'CREATE DATABASE ' + @DBName +
  ' ON 
   ( NAME = ''Trab1_dat'',
      FILENAME ='''+ @DataFileName + ''',      
      SIZE = 10,
      MAXSIZE = 50,
      FILEGROWTH = 5 )
   LOG ON
   ( NAME = ''Trab1_log'',
     FILENAME ='''+ @LogFileName + ''',
     SIZE = 5MB,
     MAXSIZE = 25MB,
     FILEGROWTH = 5MB )'

 SET NOCOUNT OFF;

/*
IF ( EXISTS( SELECT * FROM [dbo].[sysdatabases] Where name = '@DBName') )
Begin
  DROP DATABASE @DBName
end
*/


-------------------------------------------------------------------------------
--
-- Se n�o existir a BD ent�o vamos cri�-la...
-- (if not exists the database then create them)
--
IF (NOT EXISTS( SELECT * FROM [dbo].[sysdatabases] Where name = @DBName) )
Begin
  exec(@SQLString)
end


-- Criar as tabelas na base de dados rec�m-criada

-------------------------------------------------------------------------------
-- Criar as tabelas
-- (create the database tables)
-------------------------------------------------------------------------------

-- Tabela de Facturas

SET @SQLString = 
   'CREATE TABLE Factura (                               -- N�o est� em 3FN!!!
	  FacturaID int NOT NULL CHECK (FacturaID >= 1),                   
	  ClienteID int NOT NULL CHECK (ClienteID >= 1),                   
      Nome nvarchar(50) NOT NULL,                        -- Nome cliente
      Morada nvarchar(30) NOT NULL  DEFAULT ''Covilh�'',   -- Morada cliente
    
    CONSTRAINT PK_Factura PRIMARY KEY (FacturaID) -- Chave prim�ria
   )'


SET @SQLString = 'USE '+ @DBName + 
                  ' if not exists (select * from dbo.sysobjects  where id = object_id(N''[dbo].[Factura]''))  begin '+ 
				      @SQLString +' end'

EXEC ( @SQLString)    


-- Linhas da factura

SET @SQLString = 
   'CREATE TABLE FactLinha (                       
	  FacturaID int NOT NULL,
	  ProdutoID int NOT NULL,
	  
	  Designacao nvarchar (50) NOT NULL ,                                  -- Designa��o produto            
	  Preco decimal(10,2) NOT NULL  DEFAULT 10.0   CHECK (Preco >= 0.0),
	  Qtd decimal(10,2) NOT NULL  DEFAULT 1.0   CHECK (Qtd >= 0.0),         -- Qtd produto
	  
	  
	  
	  CONSTRAINT PK_FactLinha
	    PRIMARY KEY (FacturaID, ProdutoID),           -- constraint type: primary key
	  
	  
	  CONSTRAINT FK_FacturaID FOREIGN KEY (FacturaID) 
	     REFERENCES Factura(FacturaID)
	     ON UPDATE CASCADE 
	     ON DELETE NO ACTION
  )' 
SET @SQLString = 'USE '+ @DBName + 
                  ' if not exists (select * from dbo.sysobjects  where id = object_id(N''[dbo].[FactLinha]''))  begin '+ 
				      @SQLString +' end'

EXEC ( @SQLString)    
  

-- Tabela de Log
  
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql-identity-property
SET @SQLString = 
  'CREATE TABLE LogOperations (
    NumReg int IDENTITY(1,1),       -- Auto increment
	EventType char(1),              -- I, U, D (Insert, Update, Delete)
	
    -- Log
    Objecto     varchar(30),
    Valor       varchar(100),
    Referencia  varchar(100),
	
	-- Dados sobre o utilizador e posto de trabalho
    UserID nvarchar(30) NOT NULL DEFAULT USER_NAME(), 
    TerminalD      nvarchar(30) NOT NULL  DEFAULT HOST_ID(),
	TerminalName   nvarchar(30) NOT NULL  DEFAULT HOST_NAME(),
	
	-- Quanto ocorreu a opera��o
    DCriacao datetime NOT NULL DEFAULT GetDate(),
   
    CONSTRAINT PK_LogOperations PRIMARY KEY (NumReg)
  )'
  
SET @SQLString = 'USE '+ @DBName + 
                  ' if not exists (select * from dbo.sysobjects  where id = object_id(N''[dbo].[LogOperations]''))  begin '+ 
				      @SQLString +' end'

EXEC ( @SQLString)    
  