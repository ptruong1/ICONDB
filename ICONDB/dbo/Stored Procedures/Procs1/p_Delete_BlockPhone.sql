-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Delete_BlockPhone]
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
	

	DELETE FROM [tblBlockedPhones] WHERE (([PhoneNo] = @PhoneNo) AND ([FacilityID] = @FacilityID))
	SET  @UserAction =  'Delete Block phone: ' + @PhoneNo  ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,15,@ActTime ,0,@UserName ,@UserIP, @PhoneNo ,@UserAction ; 

