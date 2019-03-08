

CREATE PROCEDURE [dbo].[DELETE_UnRestrictedNumbers]
(
	@PhoneNo char(10)
	
)
AS
	SET NOCOUNT OFF;
DELETE FROM [leg_Icon].[dbo].[tblOfficeANI]
      WHERE AuthNo = @PhoneNo

