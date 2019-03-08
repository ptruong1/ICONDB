

Create PROCEDURE [dbo].[p_PAN_RecordCount]
(
	@InmateID varchar(12),
	@facilityID	int,
	@PANCount int output

)
AS
	SET NOCOUNT OFF;
	set @PANCount = 0
	select @PANCount =  COUNT(*) FROM tblPHones WHERE InmateID = @InmateID and facilityID = @facilityID
