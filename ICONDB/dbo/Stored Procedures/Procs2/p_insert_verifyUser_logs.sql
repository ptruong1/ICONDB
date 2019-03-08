CREATE PROCEDURE [dbo].[p_insert_verifyUser_logs]
	@transactionID	varchar(10),
	@errorcode		varchar(10),
	@score			varchar(4),
	@success		varchar(10),
	@status			varchar(8),
	@userID			varchar(16),
	@probability	varchar(4)
AS
	insert into  leg_Icon.dbo.tblverifyUserLogs values(@transactionID,@errorcode,@score,@success,@status,@userID,@probability)
	RETURN

