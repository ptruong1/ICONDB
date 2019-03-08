-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_video_Message_info]
@FacilityID int,
@AccountNo varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @RecordingServer as varchar(25);
	select @RecordingServer =ChatServerIP  from tblVisitPhoneServer where FacilityID = @FacilityID;

    Select  MailboxID, CAST(MailboxID as varchar(12)) + 'F' as UserID,  1 as Charge , 1 as Duration,@RecordingServer as RecordingServer  from tblMailboxF with(nolock) where facilityID = @FacilityID and AccountNo = @AccountNo ;
END

