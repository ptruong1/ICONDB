-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Delete_FreeCalls_11202017]
(
	@PhoneNo char(10),
	@FacilityID int,
	@GroupID int,
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
      ,[AcceptOpt],
      [groupID])
		SELECT 
	  [PhoneNo]
      ,[FacilityID]
      ,[FirstName]
      ,[LastName]
      ,[Descript]
      ,@Username
      ,[InputDate]
      ,GETDATE()
      ,[AuthCode]
      ,[MaxCalltime]
      ,[AcceptOpt]
      ,[groupID]
      
      From tblFreePhones
 		WHERE (([PhoneNo] = @PhoneNo) AND ([groupID]= @groupID))

	DELETE FROM [tblFreePhones] WHERE (([PhoneNo] = @PhoneNo) AND ([groupID]= @groupID))
	
	Declare @UserAction  varchar(100),@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	SET  @UserAction =  'Delete Free Call: ' + @PhoneNo  ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,8,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ;

