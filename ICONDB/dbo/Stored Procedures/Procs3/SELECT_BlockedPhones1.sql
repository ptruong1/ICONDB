
CREATE PROCEDURE [dbo].[SELECT_BlockedPhones1]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF (@FacilityID = 1 Or @FacilityID = 2)
	BEGIN
		SELECT TOP 100 PhoneNo, FacilityID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		ORDER BY inputdate DESC
	END
ELSE	IF ( @FacilityID =74 or @FacilityID =75 or @FacilityID =76)
	BEGIN
		SELECT        PhoneNo, FacilityID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		WHERE (FacilityID =74 or FacilityID =75 or FacilityID =76 ) 
		ORDER BY inputdate DESC
	END
ELSE

	BEGIN
		SELECT        PhoneNo, FacilityID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		WHERE FacilityID = @FacilityID  
		ORDER BY inputdate DESC
	END

