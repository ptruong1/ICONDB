-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_VisitInmateConfig_102314]
(
	@FacilityId int,
	@InmateID Varchar(12),
	@OrigInmateID Varchar(12),
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
	@VNote varchar(150)
)
AS
	
SET NOCOUNT OFF;

BEGIN
	IF(SELECT COUNT(*) FROM tblVisitInmateConfig where (InmateId = @OrigInmateID AND FacilityId = @FacilityId) ) > 0
		UPDATE leg_Icon.[dbo].[tblVisitInmateConfig] 
		SET
		 InmateID = @OrigInmateID
		,susStartDate = @SusStartDate
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
				
		WHERE (InmateId = @OrigInmateID AND FacilityId = @FacilityId)
	
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
	)
	

END	
If (@MaxVisitor = 0)
		Begin
		     Delete from tblVisitorInmate WHERE (InmateID = @OrigInmateID AND [FacilityId] = @FacilityId)
		End


