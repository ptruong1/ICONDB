-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_CDR_RecCount] 
	@SqltextBase Nvarchar(4000),
	@Sqltext1 Nvarchar(4000),
	@Sqltext2 Nvarchar(4000),
	@Sqltext3 Nvarchar(4000),
	@Sqltext4 Nvarchar(4000),
	@Count Int output
AS
BEGIN
	
	SET NOCOUNT ON;
Declare @SQLQuery nvarchar(Max)

set @SQLQuery = @SQLTextBase
Set @SqlQuery = @SQLQuery + @SQLText1
Set @SqlQuery = @SQLQuery + @SQLText2
Set @SqlQuery = @SQLQuery + @SQLText3
Set @SqlQuery = @SQLQuery + @SQLText4
	
	Execute sp_Executesql @SQLQuery
	
	SET @Count = @@ROWCOUNT
END

