-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_verify_officer_badge]
@facilityID int,
@ANI	char(10),
@BadgeID	int,
@RecordDate datetime
AS
BEGIN
	SET NOCOUNT ON;
    Declare @Status smallint;
	SET @Status =0;
	select @Status = [status] from tblUserprofiles with(nolock) where FacilityID = @facilityID and [ID] = @BadgeID ;
	if(@Status <>1)
	 begin
		insert tblOfficerCheckIn(facilityID, ANI , BadgeID ,RecordDate,RecordName,CheckInStatus)
			Values (@FacilityID,@ANI,@BadgeID,@RecordDate,'',@Status);
	 end
	return @status;

END

