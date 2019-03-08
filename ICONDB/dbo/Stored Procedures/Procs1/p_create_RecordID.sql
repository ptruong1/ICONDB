﻿
CREATE PROCEDURE [dbo].[p_create_RecordID]
@RecordID bigint  output

 AS
Declare @currentRecordID bigint ;
Begin tran
	Update  tblRecordID   SET  RecordID =RecordID +1;
	Select  @currentRecordID = RecordID From tblRecordID ;
Commit tran
SET @RecordID = @currentRecordID;
Return 0;

