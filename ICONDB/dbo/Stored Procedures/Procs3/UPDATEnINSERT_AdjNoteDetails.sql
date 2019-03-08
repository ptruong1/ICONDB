
CREATE PROCEDURE [dbo].[UPDATEnINSERT_AdjNoteDetails]
(
	
	@StatusID int,
	@AdjID int,
	@UserName varchar(25),
	@Note varchar(300),
	@NoteDate datetime
	
)	
AS
	SET NOCOUNT OFF;

UPDATE [tblAdjustment] SET  [Status] = @StatusID, [UserName] = @UserName
WHERE [AdjID] = @AdjID;
					
IF @Note != ''
	INSERT INTO [tblAdjustmentDetail] ([AdjID],[Note],[NoteDate],[Username]) VALUES (@AdjID,@Note,@NoteDate,@Username);
RETURN;

