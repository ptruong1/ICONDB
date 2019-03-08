

CREATE PROCEDURE [dbo].[INSERT_TroubleTicket]
(
	@TicketID int OUTPUT,
	@FacilityID int,
	@TroubleID tinyint,
	@TroubleSubject varchar(50),
	@TroubleNote varchar(500),
	@userName varchar(25),
	@ContactName varchar(40),
	@ContactEmail varchar(50),
	@ContactPhone varchar(25),
	@TroubleDate smalldatetime
)
AS
Begin
	SET NOCOUNT OFF;
    Declare  @return_value int, @nextID int, @ID int, @tblTroubleTicket nvarchar(32) ;
	Declare @UserAction  varchar(100),@ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	
	EXEC   @return_value = p_create_nextID 'tblTroubleTicket', @nextID   OUTPUT
       set           @ID = @nextID ; 
	INSERT INTO [tblTroubleTicket] ([TicketID],[FacilityID], [TroubleID], [TroubleSubject], [TroubleNote], [userName], [ContactName], [ContactEmail], [ContactPhone], [TroubleDate]) 
	VALUES (@ID, @FacilityID, @TroubleID, @TroubleSubject, @TroubleNote, @userName, @ContactName, @ContactEmail, @ContactPhone, @TroubleDate);
	SET @TicketID  = @ID;
	SET  @UserAction =  'Create Trouble Tickedt: ' + CAST(@TicketID as varchar(15)) ;	
	EXEC  INSERT_ActivityLogs3	@FacilityID ,16,@ActTime ,0,@UserName ,'',  @TicketID ,@UserAction ; 
End
