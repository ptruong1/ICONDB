
CREATE PROCEDURE [dbo].[p_Update_NewAuthID_UserbyID_UserDefined]
(	
@FacilityID int ,
@UserID varchar(20),
@ModifyBy varchar(25),
@UserIP varchar(25),
@newAuthID int OUTPUT
)
AS

SET NOCOUNT OFF;
Declare @EnCryptUser varbinary(200), @EnCryptPass varbinary(200)
Declare  @return_value int, @nextID int, @CurrentID int, @tblAuthUsers nvarchar(32) ;
		EXEC   @return_value = p_create_nextID 'tblAuthUsers', @nextID   OUTPUT
        set  @CurrentID = @nextID ;   
		SET @newAuthID = @CurrentID;

Declare  @UserAction varchar(100),@ActTime datetime;
    SET  @UserAction =  'Edit User:' + @UserID;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
    EXEC  INSERT_ActivityLogs3	@FacilityID ,5 ,@ActTime, 0,@ModifyBy ,@UserIP,@ModifyBy, @UserAction  ;

BEGIN												 		    
    UPDATE [tblUserprofiles] SET [AuthID] = @newAuthID,  [modifyBy] =@ModifyBy, [modifyDate] =getdate()
    WHERE [UserID] = @UserID;
END 
		
	

