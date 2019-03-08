
CREATE PROCEDURE [dbo].[SELECT_UnRestrictedNumbers]

AS
	SET NOCOUNT ON;
SELECT  AuthNo as PhoneNo
      ,[Description]
      ,[Billabe]
      
      FROM [leg_Icon].[dbo].[tblOfficeANI]

