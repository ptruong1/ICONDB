CREATE PROCEDURE [dbo].[p_get_Inmate_Info_API]
@userID	varchar(25),
@password	varchar(25),
@clientID	varchar(10),
@siteID		int,
@siteIP		varchar(16),
@FirstName	VARCHAR(25),
@LastName	VARCHAR(25),
@InmateID	varchar(12)

AS
--SET NoCount ON
declare  @replyCode varchar(3), @status smallint, @userlevel tinyint
SET @replyCode ='000'
exec p_verify_client_info_API  @userID	,  @password	,@clientID	,@siteID,@siteIP, @replyCode	 OUTPUT,@userlevel OUTPUT

if( @replyCode ='000') 
 Begin
	if (@InmateID <> '') 
		Select  @replyCode as Authcode,  FirstName, LastName, InmateID, status  From leg_Icon.dbo.tblInmate where facilityID =@siteID and   inmateID = @InmateID
	else if( @FirstName <>''  and  @LastName <> '' )
		Select  @replyCode as Authcode,  FirstName, LastName, InmateID, status  From leg_Icon.dbo.tblInmate where facilityID =@siteID and  FirstName like '%' + @FirstName + '%' and LastName like  '%' + @LastName + '%' 
	else if( @FirstName <>''  )
		Select  @replyCode as Authcode,  FirstName, LastName, InmateID, status  From leg_Icon.dbo.tblInmate where facilityID =@siteID and FirstName like '%' + @FirstName + '%' 
	else if( @LastName <> '' )
		Select  @replyCode as Authcode,  FirstName, LastName, InmateID, status  From leg_Icon.dbo.tblInmate where facilityID =@siteID and LastName like  '%' + @LastName + '%' 
	else
		Select  @replyCode as Authcode,  FirstName, LastName, InmateID, status  From leg_Icon.dbo.tblInmate where facilityID =@siteID
	
 End
--else

if(@@rowcount=0)
	Select  @replyCode as Authcode,'' as   FirstName,'' as  LastName,'' as  InmateID, 0 as  status  
Return 0;
