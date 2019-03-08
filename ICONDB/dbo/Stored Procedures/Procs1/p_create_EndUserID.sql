-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[p_create_EndUserID]
@EndUserID int  output
AS
Begin
	Declare @currentRecordID bigint 
	Begin tran
		Select  @currentRecordID= EndUserID From tblEndUserID 
		SET  @currentRecordID=  @currentRecordID + 1
		Update  tblEndUserID   SET  EndUserID = @currentRecordID
	Commit tran
	SET @EndUserID = @currentRecordID
End

