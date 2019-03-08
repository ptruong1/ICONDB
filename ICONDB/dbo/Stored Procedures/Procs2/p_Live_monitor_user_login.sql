

CREATE PROCEDURE  [dbo].[p_Live_monitor_user_login]
@userName  varchar(20),
@password	varchar(20)
AS
Declare @loginID	bigint, @FacilityID int
set @FacilityID =0

select isnull( FacilityID,0)  as FacilityID  from  tbluserprofiles   with(nolock), tblauth with(nolock) where  tbluserprofiles.authID= tblauth.authID and  userID = @userName and password = @password and  ( tblauth.monitor =1 Or tblauth.admin=1)
return   @FacilityID

