-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_NonRecordablePhone1]
(
	@PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
	Insert INTO tblNonRecordPhonesRemoved (
      [PhoneNo]
      ,[FacilityID]
      ,[LastName]
      ,[FirstName]
      ,[DescriptID]
      ,[UserName]
      ,[Inputdate]
      ,[modifyDate]
      ,[Note])
	SELECT [PhoneNo]
      ,[FacilityID]
      ,[LastName]
      ,[FirstName]
      ,[DescriptID]
      ,[UserName]
      ,[Inputdate]
      ,[modifyDate]
      ,[Note]
      
	FROM tblNonRecordPhones
	WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))

	DELETE FROM [tblNonRecordPhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))


