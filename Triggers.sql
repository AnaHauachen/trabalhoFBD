Use TBD_TRAB1

-- --------------------------------------------------------

--
-- Criação Trigger RefreshUpdate
--

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[InsertLog_FactLinha] ON [dbo].[FactLinha]
		INSTEAD OF INSERT 
		AS
		BEGIN
			SET NOCOUNT ON;

			DECLARE
				 @FactID varchar(30),
				 @aux int
		 
				 SET @aux = (SELECT MAX(FacturaID)
				 FROM [dbo].[FactLinha])

				 SET @FactID = @aux + 1 + ':999'
		

			INSERT INTO [dbo].[LogOperations]
						([EventType]
						,[Objecto]
						,[Valor]
						,[Referencia])
			VALUES
				  ('I'
				  ,'Begin'
				  ,GETDATE()
				  ,)
			
			
			END
			
GO
ALTER TABLE [dbo].[FactLinha] ENABLE TRIGGER [InsertLog_FactLinha]
GO