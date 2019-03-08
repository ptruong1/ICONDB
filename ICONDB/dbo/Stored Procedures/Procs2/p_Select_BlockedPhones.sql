CREATE PROCEDURE [dbo].[p_Select_BlockedPhones]
(
	@GroupID int
)
AS
	SET NOCOUNT ON;
IF (@GroupID = 1 Or @GroupID = 2  or  @GroupID  = 0)
	BEGIN
		SELECT  PhoneNo, GroupID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited, A.Descript as [Note], A.RequestID as RequestID
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		--WHERE GroupID = @GroupID  
		ORDER BY inputdate DESC
	END
ELSE	IF ( @GroupID =74 or @GroupID =75 or @GroupID =76)
	BEGIN
		SELECT        PhoneNo, GroupID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited, A.Descript as [Note], A.RequestID as RequestID
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		WHERE (GroupID =74 or GroupID =75 or GroupID =76 ) 
		ORDER BY inputdate DESC
	END
ELSE

	BEGIN
		SELECT        PhoneNo, GroupID, Username, A.ReasonID, T.Description as [Description], InputDate, R.Descript as [RequestReason], TimeLimited, A.Descript as [Note], A.RequestID as RequestID
		FROM            tblBlockedPhones A   with(nolock)  INNER JOIN tblBlockedReason T   with(nolock)  ON T.ReasonID = A.ReasonID
						INNER JOIN tblBlockedRequest R ON A.RequestID = R.RequestID
		WHERE GroupID = @GroupID  
		ORDER BY inputdate DESC
	END

