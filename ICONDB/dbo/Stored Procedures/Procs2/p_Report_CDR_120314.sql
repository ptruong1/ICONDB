-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_CDR_120314] 
	@Sqltext Nvarchar(4000)
AS
BEGIN
	
	SET NOCOUNT ON;
Declare @SQLQuery nvarchar(4000)
Set @SQLQuery = @SqlText
    
	Execute sp_Executesql @SQLQuery
END

