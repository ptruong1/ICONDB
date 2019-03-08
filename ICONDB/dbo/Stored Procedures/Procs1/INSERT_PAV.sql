-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_PAV]
(
	@facilityID	int,
	@VisitorID int,
	@InmateID varchar(12),
	@InputDate dateTime,
	@ModifyDate datetime,
	@UserName varchar(25)

)
AS
	SET NOCOUNT OFF;
	DECLARE @PAVCount int;
SELECT @PAVCount = MaxVisitor FROM tblVisitInmateConfig WHERE InmateID = @InmateID  and facilityID = @facilityID	 ;
IF @PAVCount <= (SELECT COUNT(*) FROM tblVisitorInmate WHERE InmateID = @InmateID and facilityID = @facilityID)
	RETURN -2;
IF @VisitorID in (SELECT visitorID FROM tblVisitorInmate WHERE InmateID = @InmateID and facilityID = @facilityID)
	RETURN -1 ;
ELSE
	BEGIN
		INSERT INTO [tblVisitorInmate] ([VisitorID], [InmateID], InputDate, ModifyDate, UserName, FacilityID) 
			VALUES (@VisitorID, @InmateID, @InputDate, @ModifyDate, @UserName, @FacilityID);
		RETURN 0;
	END


