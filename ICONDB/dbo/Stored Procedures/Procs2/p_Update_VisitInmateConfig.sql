-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Update_VisitInmateConfig]
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
	
SET NOCOUNT OFF;
	declare @ActTime datetime;

	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
BEGIN
	IF(SELECT COUNT(*) FROM tblVisitInmateConfig where (InmateId = @InmateID AND FacilityId = @FacilityId) ) > 0
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
		,VNote = @VNote
		,VisitRemain = @VisitRemain		
		WHERE (InmateId = @InmateID AND FacilityId = @FacilityId)
	
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
	)
	

END	
If (@MaxVisitor = 0)
		Begin
		     Delete from tblVisitorInmate WHERE (InmateID = @InmateID AND [FacilityId] = @FacilityId)
		End

EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,	@UserIP,	@InmateID,@UserAction
