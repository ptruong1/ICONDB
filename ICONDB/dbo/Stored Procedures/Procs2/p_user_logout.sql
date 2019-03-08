
CREATE PROCEDURE [dbo].[p_user_logout]
@loginID	bigint

AS
SET NOCOUNT ON;

Declare @facilityID int, @UserName varchar(20),@IPaddress	varchar(16);
Declare  @UserAction varchar(100),@ActTime datetime;
SET  @UserAction =  'Logout';
select @facilityID =facilityID, @UserName= a.username , @IPaddress = a.IpAddess  from tblUserLogs a inner join tblUserprofiles  b on (a.userName = b.UserID ) 
Where a.LoginID =  @loginID;


EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

EXEC  INSERT_ActivityLogs3	@FacilityID ,20 ,@ActTime, 0,@UserName ,@IPaddress, @loginID,@UserAction ;  
/*
Insert tblActivityLog (ActivityID ,ActTime ,RecordID , FacilityID , UserName,UserIP,Reference)

select 20,GETDATE(),0,facilityID, a.username,a.IpAddess ,@loginID from tblUserLogs a inner join tblUserprofiles  b on (a.userName = b.UserID ) 
Where a.LoginID =  @loginID;
*/
Update tblUserLogs  SET  logouttime = @ActTime where loginID	= @loginID;



