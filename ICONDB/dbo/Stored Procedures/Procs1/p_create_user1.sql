

CREATE PROCEDURE [dbo].[p_create_user1]
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
@Description  varchar(50),
@Createby	varchar(20)
 AS
Declare  @authID smallint, @userLevel smallint
insert tblAuth ( admin, monitor, finance ,dataEntry, Description ) 
values (@admin ,@monitor ,@finance ,@dataEntry ,@Description  ) 

SET @FacilityID = isnull(@FacilityID,0)
SET  @AgentID = isnull(@AgentID,0)
SET @authID = @@identity
If(@AgentID =1  and  @FacilityID =1)  set  @userLevel  =1
Else if(@FacilityID >0)  set  @userLevel  =3
Else If(@AgentID > 1 and  @FacilityID =0)  set  @userLevel  =2

Insert tblUserprofiles (UserID ,  Password, FacilityID , AgentID, LastName ,  FirstName ,  MidName ,  Department , authID, Phone , Email, userLevel, Createdby) 

values(@UserID,@Password  , @FacilityID , @AgentID , @LastName  ,@FirstName   ,@MidName  ,@Department  , @authID, @Phone  ,@Email,  @userLevel ,@Createby )


