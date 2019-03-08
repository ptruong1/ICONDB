-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_CDR_01182016] 
	@Sqltext Nvarchar(Max)
AS
BEGIN
	
	SET NOCOUNT ON;
Declare @SQLQuery nvarchar(4000)
Set @SQLQuery = @SqlText
    
	Execute sp_Executesql @SQLQuery
END

