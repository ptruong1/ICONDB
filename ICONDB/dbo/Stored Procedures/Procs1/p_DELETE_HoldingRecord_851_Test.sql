-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_DELETE_HoldingRecord_851_Test]
(
	@RecordID int,
	@Extension varchar(10)
)
AS
	SET NOCOUNT OFF;
delete dbo.tblRecordingListTransHolder
			where RecordID= @RecordID and extension = @Extension;
begin
	if @Extension = '-Out.wav'
		update dbo.tblRecordingListTrans set [status]=2
		, OutStatus = 3
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	else
		update dbo.tblRecordingListTrans set [status]=2
		, InStatus = 3
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	end
