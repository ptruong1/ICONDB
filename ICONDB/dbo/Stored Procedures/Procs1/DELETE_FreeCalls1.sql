-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_FreeCalls1]
(
	@PhoneNo char(10),
	@FacilityID int
)
AS
	SET NOCOUNT OFF;
	INSERT tblFreePhonesRemoved 
	  ([PhoneNo]
      ,[FacilityID]
      ,[FirstName]
      ,[LastName]
      ,[Descript]
      ,[Username]
      ,[InputDate]
      ,[ModifyDate]
      ,[AuthCode]
      ,[MaxCalltime]
      ,[AcceptOpt])
		SELECT 
	  [PhoneNo]
      ,[FacilityID]
      ,[FirstName]
      ,[LastName]
      ,[Descript]
      ,[Username]
      ,[InputDate]
      ,[ModifyDate]
      ,[AuthCode]
      ,[MaxCalltime]
      ,[AcceptOpt]
      
      From tblFreePhones
 		WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))

	DELETE FROM [tblFreePhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))


