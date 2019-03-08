-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_VisitInmateConfig]
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
	@ExtID varchar(12),
	@AtLocation int
)
AS
	
SET NOCOUNT OFF;

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
		,AtLocation
		,ExtID 
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
		,@AtLocation
		,@ExtID 
	)
	

END	
If (@MaxVisitor = 0)
		Begin
		     Delete from tblVisitorInmate WHERE (InmateID = @InmateID AND [FacilityId] = @FacilityId)
		End


