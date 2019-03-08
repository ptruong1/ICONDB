
CREATE PROCEDURE [dbo].[p_update_LiB_reply]
@phoneNo	char(10),
@replycode	char(3)
 AS
if(select count(*)  from  tblLibReply  with(nolock) where phoneNo = @phoneNo)  = 0
begin
	Insert tblLibReply(PhoneNo ,   ReplyCode)  Values(@phoneNo,@replycode)
end
Else
begin
	update tblLibReply  SET Replycode = @replycode, modifyDate = getdate()  where phoneNo = @phoneNo
end

