-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_create_nextID]
@tableName nvarchar(32),
@nextID bigint OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

	select @nextID = CurrentID from tblIndtables where tableName= @tableName;
	Update tblIndtables SET CurrentID = CurrentID +1  from tblIndtables where tableName= @tableName;
	select @nextID = CurrentID from tblIndtables where tableName= @tableName;

END

