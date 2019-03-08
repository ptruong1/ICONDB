

CREATE PROCEDURE [dbo].[UPDATEnINSERT_TroubleTicketDetails]
(
	@ContactName varchar(40),
	@ContactEmail varchar(50),
	@ContactPhone varchar(25),
	@StatusID int,
	@ResolveDate smalldatetime,
	@TicketID int,
	@UserName varchar(25),
	@LegacyDetailNote varchar(500),
	@ReplyDetailNote varchar(500),
	@AssignedTo varchar(30)
)	
AS
	SET NOCOUNT OFF;

UPDATE [tblTroubleTicket] SET [ContactName] = @ContactName, [ContactEmail] = @ContactEmail, [ContactPhone] = @ContactPhone, [StatusID] = @StatusID, [ResolveDate] = @ResolveDate
WHERE [TicketID] = @TicketID;
					
IF @ReplyDetailNote != ''
	INSERT INTO [tblTroubleTicketDetail] ([TicketID],[LegacyDetailNote],[ReplyDetailNote],[AssignedTo],[Username]) VALUES (@TicketID,@LegacyDetailNote,@ReplyDetailNote,@AssignedTo,@Username);
RETURN;

