-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_voice_message]
@FacilityID int,
@InmateID varchar(12),
@MessageName	varchar(50),
@ReadCount tinyint

AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @MailBoxID int;

	select @MailBoxID = MailboxID from tblMailbox where FacilityID= @FacilityID and InmateID= @inmateID;
	--select @MailBoxID;
	update tblMailboxDetail set IsNew =0 , readcount =@ReadCount where MailBoxID = @MailBoxID and MessageName = @MessageName;

	if(@@error =0)
		select 1 as Success;
	else
		select 1 as Fail;
END

