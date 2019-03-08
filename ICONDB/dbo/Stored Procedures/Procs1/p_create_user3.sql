
CREATE PROCEDURE [dbo].[p_create_user3]
@UserID varchar(20),  
@Password  varchar(20),
@FacilityID int ,
@AgentID  int,
@LastName  varchar(20)  ,  
@FirstName   varchar(20),  
@MidName  varchar(15) ,  
@Department  varchar(25) , 
@Phone  char(10) , 
@Email  varchar(50),
@admin  bit, 
@monitor  bit,
@finance  bit ,
@dataEntry  bit,
@Controler  bit,
@Description  varchar(50),
@Createby	varchar(20),
@IPAddress  varchar(16)
 AS
Declare  @authID smallint, @userLevel smallint, @EnCryptUser varbinary(1000), @EnCryptPass varbinary(1000)
Declare  @return_value int, @nextID int, @CurrentID int, @tblAuthUsers nvarchar(32) ;

       EXEC   @return_value = p_create_nextID 'tblAuth', @nextID   OUTPUT
       set           @CurrentID = @nextID ; 
insert tblAuth (AuthID, admin, monitor, finance ,dataEntry, Description,controler ) 
values (@CurrentID, @admin ,@monitor ,@finance ,@dataEntry ,@Description,@controler  ) 

SET @FacilityID = isnull(@FacilityID,0)
SET  @AgentID = isnull(@AgentID,0)
SET @authID = @CurrentID
If(@AgentID =1  and  @FacilityID =1)  set  @userLevel  =1
Else if(@FacilityID >0)  set  @userLevel  =3
Else If(@AgentID > 1 and  @FacilityID =0)  set  @userLevel  =2

--exec [dbo].[LegEncrypt] @UserID,	@EnCryptUser  OUTPUT
--EXEC [dbo].[LegEncrypt] @password,	@EnCryptPass  OUTPUT

Insert tblUserprofiles (UserID ,  Password, FacilityID , AgentID, LastName ,  FirstName ,  MidName ,  Department , authID, Phone , Email, userLevel, Createdby, IPaddress, UserIDDEC, PasswordDEC) 

values(@UserID, @password, @FacilityID , @AgentID , @LastName  ,@FirstName   ,@MidName  ,@Department  , @authID, @Phone  ,@Email,  @userLevel ,@Createby,@IPaddress,@EnCryptUser , @EnCryptPass)

EXEC  INSERT_ActivityLogs1   @FacilityID,5, 0,	@Createby,@IPAddress,	@UserID
