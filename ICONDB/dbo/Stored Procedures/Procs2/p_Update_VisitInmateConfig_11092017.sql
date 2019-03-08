-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Update_VisitInmateConfig_11092017]
(
	@FacilityId int,
	@InmateID Varchar(12),
	@SusStartDate datetime,
	@SusEndDate datetime,
	@ApprovedReq bit,
	@PAV bit,
	@MaxVisitor int,
	@VisitPerDay int,
	@VisitPerWeek int,
	@VisitPerMonth int,
	@MaxVisitTime int,
	@ExtID varchar(12),
	@AtLocation varchar(20),
	@LocationID int,
	@VNote varchar(150),
	@UserIP varchar(25),
	@UserAction varchar(50),
	@UserName varchar(20),
	@VisitRemain int
)
AS
BEGIN	
   SET NOCOUNT OFF;
	declare @ActTime datetime, @CurrLocationID int ;
	SET @CurrLocationID =0;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
	IF(SELECT COUNT(*) FROM tblVisitInmateConfig where (InmateId = @InmateID AND FacilityId = @FacilityId) ) > 0
	 begin
	    select @CurrLocationID= locationID from tblVisitInmateConfig where (InmateId = @InmateID AND FacilityId = @FacilityId) ;
		If (@CurrLocationID <> @LocationID)
			Update tblVisitEnduserSchedule set locationID = @LocationID, Note='Inmate Move', adjustedDate = getdate() where (InmateId = @InmateID AND FacilityId = @FacilityId) and status in (1,2);
		UPDATE leg_Icon.[dbo].[tblVisitInmateConfig] 
		SET		 
		 susStartDate = @SusStartDate
		,SusEndDate = @SusEndDate
		,ApprovedReq = @ApprovedReq
		,PAV = @PAV 
		,MaxVisitor = @MaxVisitor
		,VisitPerDay = @VisitPerDay 
		,VisitPerWeek = @VisitPerWeek
		,VisitPerMonth = @VisitPerMonth
		,AtLocation = @AtLocation
		,ExtID = @ExtID 
		,LocationID = @LocationID
		,MaxVisitTime = @MaxVisitTime
		,VisitRemain = @VisitRemain		
		WHERE (InmateId = @InmateID AND FacilityId = @FacilityId);
	 end
	
	ELSE
		INSERT INTO [leg_Icon].[dbo].[tblVisitInmateConfig]
	(
         FacilityID 
		,InmateID
        ,susStartDate 
		,SusEndDate 
		,ApprovedReq 
		,PAV 
		,MaxVisitor
		,VisitPerDay
		,VisitPerWeek
		,VisitPerMonth
		,MaxVisitTime 
		,AtLocation
		,ExtID 
		,LocationID
		,VNote
		,VisitRemain
	)
     VALUES
           (
         @FacilityID
		,@InmateID 
         ,@susStartDate 
		,@SusEndDate 
		,@ApprovedReq 
		,@PAV 
		,@MaxVisitor
		,@VisitPerDay
		,@VisitPerWeek
		,@VisitPerMonth
		,@MaxVisitTime 
		,@AtLocation
		,@ExtID 
		,@LocationID
		,@VNote
		,@VisitRemain
	);
	------Insert Video note
	if (@VNote <>'')
		begin
			Declare @return_value int, @nextID int, @ID int, @tblInmateNote nvarchar(32) ;
			EXEC	@return_value = p_create_nextID 'tblInmateNote', @nextID   OUTPUT
			set		@ID = @nextID	;
			INSERT INTO tblInmateNote ([NoteID],[NoteTypeID],[FacilityID] ,[InmateID], [Note], [InputDate], [UserName])
			 VALUES (@ID ,3,@FacilityId, @InmateID, @VNote, getdate(), @UserName);
		end
	If (@MaxVisitor = 0)
		Begin
		     Delete from tblVisitorInmate WHERE (InmateID = @InmateID AND [FacilityId] = @FacilityId);
		End

	EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,	@UserIP,	@InmateID,@UserAction

END	
	

