-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_DELETE_HoldingRecord]
(
	@RecordID int,
	@Extension varchar(10)
)
AS
	SET NOCOUNT OFF;
delete leg_Icon.dbo.tblRecordingListTransHolder
			where RecordID= @RecordID and extension = @Extension;
begin
	if @Extension = '-Out.wav'
		update leg_Icon.dbo.tblRecordingListTrans set [status]=2
		, OutStatus = 3
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	else
		update leg_Icon.dbo.tblRecordingListTrans set [status]=2
		, InStatus = 3
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	end
