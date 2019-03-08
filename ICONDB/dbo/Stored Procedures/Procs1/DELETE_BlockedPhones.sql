-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_BlockedPhones]
(
	@PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
	INSERT tblBlockedPhonesRemoved 
	  ([PhoneNo]
      ,[FacilityID]
      ,[ReasonID]
      ,[RequestID]
      ,[UserName]
      ,[inputDate]
      ,[TimeLimited]
      ,[Descript])
		SELECT 
	  [PhoneNo]
      ,[FacilityID]
      ,[ReasonID]
      ,[RequestID]
      ,[UserName]
      ,[inputDate]
      ,[TimeLimited]
      ,[Descript]
		FROM tblBlockedPhones

		WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))

	DELETE FROM [tblBlockedPhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))


