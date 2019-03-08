

CREATE PROCEDURE [dbo].[p-Select_VisitPhone_By_Facility]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        [ExtID],[StationID],[RecordOpt],[LimitTime],A.PinRequired,[status], S.Descript as Description
FROM            [leg_Icon].[dbo].[tblVisitPhone] A   with(nolock)
		
		INNER JOIN tblPhoneStatus S with(nolock) ON A.Status =  S.StatusID
		
WHERE        (A.facilityID = @FacilityID)
ORDER BY A.inputdate DESC

