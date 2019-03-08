

CREATE PROCEDURE [dbo].[UPDATEnINSERT_TroubleTicketDetails_09182015]
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
	@AssignedTo varchar(30),
	@ServiceLevelID int,
	@ServiceDeptID int
)	
AS
	SET NOCOUNT OFF;

UPDATE [tblTroubleTicket] SET [ContactName] = @ContactName, [ContactEmail] = @ContactEmail, [ContactPhone] = @ContactPhone, [StatusID] = @StatusID, [ResolveDate] = @ResolveDate, [ServiceLevelID] = @ServiceLevelID, [AssignDeptID] = @ServiceDeptID
WHERE [TicketID] = @TicketID;
					
IF @ReplyDetailNote != ''
Declare  @return_value int, @nextID int, @ID int, @tblTroubleTicketDetail nvarchar(32) ;
	    EXEC   @return_value = p_create_nextID 'tblTroubleTicketDetail', @nextID   OUTPUT
       set           @ID = @nextID ;   
      INSERT INTO [tblTroubleTicketDetail] ([DetailID] ,[TicketID],[LegacyDetailNote],[ReplyDetailNote],[AssignedTo],[Username]) 
          VALUES (@ID, @TicketID,@LegacyDetailNote,@ReplyDetailNote,@AssignedTo,@Username);
RETURN;

--UPDATE [tblTroubleTicket] SET [ContactName] = @ContactName, [ContactEmail] = @ContactEmail, [ContactPhone] = @ContactPhone, [StatusID] = @StatusID, [ResolveDate] = @ResolveDate, [ServiceLevelID] = @ServiceLevelID, [AssignDeptID] = @ServiceDeptID
--WHERE [TicketID] = @TicketID;
					
--IF @ReplyDetailNote != ''
--	INSERT INTO [tblTroubleTicketDetail] ([TicketID],[LegacyDetailNote],[ReplyDetailNote],[AssignedTo],[Username]) VALUES (@TicketID,@LegacyDetailNote,@ReplyDetailNote,@AssignedTo,@Username);
--RETURN;

