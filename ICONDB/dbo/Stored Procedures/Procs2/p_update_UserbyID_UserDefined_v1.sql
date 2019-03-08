
CREATE PROCEDURE [dbo].[p_update_UserbyID_UserDefined_v1]
(	
@FacilityID int ,
@Password  varchar(20),
@UserID varchar(20),
@LastName  varchar(20)  ,  
@FirstName   varchar(20),  
@MidName  varchar(15) ,  
@ID int, 
@Department  varchar(25) , 
@Phone  char(10) , 
@Email  varchar(50),
@status tinyint,
@IPAddress  varchar(16),
@ModifyBy varchar(25),
@UserIP varchar(25),
@SecondFactor bit,
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
	   if(@Password <>'' and @Password <>'****')
		begin
			UPDATE [tblUserprofiles] SET  [AuthID] = @newAuthID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName,[ID] = @ID, [Department] = @Department, [Phone] = @Phone, [Email] = @Email ,
									     [Password] = @password , [status] = @status, [IPaddress]=@IPaddress, UserIDDEC= @EnCryptUser, PasswordDEC = @EnCryptPass, SecondFactor = @SecondFactor, [modifyBy] =@ModifyBy, [modifyDate] =getdate()
			WHERE [UserID] = @UserID; 
		end
		else
			UPDATE [tblUserprofiles] SET [AuthID] = @newAuthID, [LastName] = @LastName, [FirstName] = @FirstName, [MidName] = @MidName,[ID] = @ID, [Department] = @Department, [Phone] = @Phone, [Email] = @Email ,
									  [status] = @status, [IPaddress]=@IPaddress, SecondFactor = @SecondFactor, [modifyBy] =@ModifyBy, [modifyDate] =getdate()
		    WHERE [UserID] = @UserID; 
		END

	
	

