CREATE PROCEDURE [dbo].[p_verify_client_info_API]
@userID	varchar(25),
@password	varchar(25),
@clientID	varchar(10),
@siteID		int,
@siteIP		varchar(16),
@replyCode	varchar(3) OUTPUT,
@userlevel        tinyint OUTPUT
 AS

SET nocount on;

SET @userlevel  =0;
SET @replyCode ='000';
--SELECT @userlevel  = userLevel  from tblclientusers  with(nolock) where  clientID=@clientID and siteIP=@siteIP  and siteID = @siteID  and username= @userID and [password]= @password
SELECT @userlevel  = userLevel  from tblclientusers  with(nolock) where  clientID=@clientID  and siteID = @siteID  and username= @userID ;-- and [password]= @password;
if(@siteID =1)
	SELECT @userlevel  = userLevel  from tblclientusers  with(nolock) where  clientID=@clientID  and siteID = @siteID  ;
if  (@userlevel  =0)
 begin
	if(select count(*)  from tblclient with(nolock)  where clientID=@clientID) =0
		SET  @replyCode ='001';	
	else if (select  count(*) from tblclientusers  with(nolock) where siteIP=@siteIP ) = 0
		SET  @replyCode ='003';
	else if (select  count(*) from tblclientusers  with(nolock) where  siteID = @siteID ) = 0 
		SET  @replyCode ='002';
	else       
		SET  @replyCode ='004';
 end



if(@@error <>0)
	SET  @replyCode  ='100';

--Insert tblClientLogs(ClientID ,  UserName  ,  Password  ,   SiteID,  SiteIPadd ,  AcessTime   ,     AccessCode )
	--values( @clientID,@userID	,@password,@siteID		,@siteIP,getdate(),  @replyCode)
