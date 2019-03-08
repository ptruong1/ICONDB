CREATE PROCEDURE [dbo].[p_get_phone_type]
@phoneNo	varchar(15),
@replycode	varchar(3) OUTPUT
AS

set @replycode ='999'
select   @replycode = replycode from tblEndUser with(nolock) where billtono =@phoneNo
