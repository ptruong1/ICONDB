
CREATE PROCEDURE [dbo].[UPDATE_UnRestrictedNumbers]
(
	@PhoneNo char(10),
	@Description Varchar(50),
	@Billabe int
)
AS

UPDATE [leg_Icon].[dbo].[tblOfficeANI]
   SET [AuthNo] = @PhoneNo
      ,[Description] = @Description
      
 WHERE AuthNo = @PhoneNo

