CREATE proc [dbo].[p_update_isNew_inbox_picture_messages_by_inmate]
 @InmateID varchar(12),
 @FacilityID int,
 @MessageID int,
 @IsNewValue int 
as
begin
	declare @MailboxID int
	Begin try
		select @MailboxID= MailBoxID from tblMailbox where FacilityID=@FacilityID and InmateID=@InmateID

		update tblMailboxDetail
		set IsNew=@IsNewValue
		where MessageTypeID=5 and MailBoxID=@MailboxID and MessageID=@MessageID

	end try
	Begin Catch
		return ERROR_NUMBER();
	End Catch
end