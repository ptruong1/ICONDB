

Create PROCEDURE [dbo].[p_PRN_RecordCount]
(
	@InmateID varchar(12),
	@facilityID	int,
	@PRNCount int output

)
AS
	SET NOCOUNT OFF;
	set @PRNCount = 0
	select @PRNCount =  COUNT(*) FROM tblBlockedPhonesByPIN WHERE InmateID = @InmateID and facilityID = @facilityID
