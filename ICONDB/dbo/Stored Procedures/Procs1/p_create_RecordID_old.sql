
CREATE PROCEDURE [dbo].[p_create_RecordID_old]
@RecordID bigint  output

 AS
Declare @currentRecordID bigint ;
Begin tran
	Select  @currentRecordID = RecordID From tblRecordID ;
	SET  @currentRecordID=  @currentRecordID + 1;
	Update  tblRecordID   SET  RecordID = @currentRecordID;
Commit tran
SET @RecordID = @currentRecordID;

