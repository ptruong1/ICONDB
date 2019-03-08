-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Delete_NonRecordablePhone]
(
	@PhoneNo char(10),
	@FacilityID int,
	@UserName varchar(25),
	@UserIP varchar(25)
	
)
AS
	SET NOCOUNT OFF;
	Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
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
	SET  @UserAction =  'Delete Non-recordable phone: ' + @PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,17,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ; 

