

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_Form_Status] 
(
	@FormType int
)
AS
	SET NOCOUNT ON;
IF @FormType = 3
	BEGIN
		SELECT [statusID]
      ,[Descript]
		FROM [leg_Icon].[dbo].[tblFormstatus]
	END
ELSE
	BEGIN
		SELECT TOP 1000 [statusID]
      ,[Descript]
  FROM [leg_Icon].[dbo].[tblFormstatus]
  where statusID = 1 or statusID = 2 or statusID = 15
END 


