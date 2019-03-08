-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Delete_FreeCalls]
(
	@PhoneNo char(10),
	@FacilityID int,
	@Username varchar(25),
	@UserIP varchar(25)
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
	
	Declare @UserAction  varchar(100),@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	SET  @UserAction =  'Delete Free Call: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,8,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;
