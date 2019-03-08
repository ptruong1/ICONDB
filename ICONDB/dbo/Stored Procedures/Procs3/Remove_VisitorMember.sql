
CREATE PROCEDURE [dbo].[Remove_VisitorMember]
(
	@MemberID int
	)
AS

	BEGIN
		UPDATE [tblVisitorMembers] SET [Status] = 3
		WHERE MemberID = @MemberID;
		RETURN 0;
	END




