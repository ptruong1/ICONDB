
CREATE PROCEDURE [dbo].[p_user_logout1]
@LoginID	bigint,
@FacilityID	int,
@UserName varchar(20),
@IPaddress	varchar(16)

AS
SET NOCOUNT ON;
Declare  @UserAction varchar(100),@ActTime datetime;
SET  @UserAction =  'Logout from IP Address:' +  @IPaddress ;
EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,20 ,@ActTime, 0,@UserName ,@IPaddress, @loginID,@UserAction ;    
--Insert tblActivityLog (ActivityID ,ActTime ,RecordID , FacilityID , UserName,UserIP,Reference)
--values( 20,GETDATE(),0,@FacilityID ,@UserName,@IPaddress,@LoginID)  ;
Update tblUserLogs  SET  logouttime = @ActTime where loginID	= @loginID;

EXEC [172.77.10.22\bigdaddyicon].Leg_LiveCast.dbo.p_update_user_activity @UserName, @FacilityID, 20, @UserAction,@ActTime;



