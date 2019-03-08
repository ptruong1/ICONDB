-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[p_create_VisitorID]
@VisitorID int  output
AS
Begin
	Declare @currentRecordID bigint 
	Begin tran
		Select  @currentRecordID= VisitorID From tblvisitorID
		SET  @currentRecordID=  @currentRecordID + 1
		Update  tblvisitorID   SET  VisitorID = @currentRecordID
	Commit tran
	SET @VisitorID = @currentRecordID
End



