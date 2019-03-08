

CREATE PROCEDURE [dbo].[p_UPDATEnINSERT_TroubleTicketDetailsfromAgent]
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
	@ServiceDeptID int,
	@UserIP varchar(25),
	@FacilityID int
)	
AS
	SET NOCOUNT OFF;
Declare @UserAction  varchar(100),@ActTime datetime;
EXEC [p_get_facility_time] @FacilityID ,@ActTime OUTPUT ;
SET  @UserAction =  'Update Trouble Tickedt: ' + CAST(@TicketID as varchar(15)) ;	
EXEC  INSERT_ActivityLogs3	@FacilityID ,16,@ActTime ,0,@UserName ,@UserIP,  @TicketID ,@UserAction ; 

UPDATE [tblTroubleTicket] SET [ContactName] = @ContactName, [ContactEmail] = @ContactEmail, [ContactPhone] = @ContactPhone, [StatusID] = @StatusID, [ResolveDate] = @ResolveDate, [ServiceLevelID] = @ServiceLevelID, [AssignDeptID] = @ServiceDeptID
WHERE [TicketID] = @TicketID;
					
IF @ReplyDetailNote != ''
Declare  @return_value int, @nextID int, @ID int, @tblTroubleTicketDetail nvarchar(32) ;
	    EXEC   @return_value = p_create_nextID 'tblTroubleTicketDetail', @nextID   OUTPUT
       set           @ID = @nextID ;  
	INSERT INTO [tblTroubleTicketDetail] ([DetailID],[TicketID],[LegacyDetailNote],[ReplyDetailNote],[AssignedTo],[Username]) VALUES (@ID,@TicketID,@LegacyDetailNote,@ReplyDetailNote,@AssignedTo,@Username);
	
RETURN;
