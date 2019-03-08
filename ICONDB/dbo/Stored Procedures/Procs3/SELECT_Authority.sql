
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_Authority] 
(
	@authID int
	
)
AS
	SET NOCOUNT ON;

	SELECT TOP 1000 [authID]
      ,[admin]
      ,[monitor]
      ,[finance]
      ,[dataEntry]
      ,[Description]
      ,[inputdate]
      ,[controler]
  FROM [leg_Icon].[dbo].[tblAuth] where authID = @authID
