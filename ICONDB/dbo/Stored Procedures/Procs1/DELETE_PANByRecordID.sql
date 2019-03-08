


CREATE PROCEDURE [dbo].[DELETE_PANByRecordID]
(
	@RecordID bigint
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblPhones] WHERE (RecordID=@RecordID)



