CREATE PROCEDURE [dbo].[p_change_Inmate_PIN]
@InmateID varchar(12),
@facilityID	int,
@CurrentPIN varchar(12),
@NewPIN		varchar(12)
 AS
 SET NOCOUNT ON;

 Update tblInmate set PIN = @NewPIN where InmateID = @InmateID and FacilityId = @facilityID and PIN = @CurrentPIN ;

If @@ERROR= 0 
	select 1 as ChangePINStatus;
else
	select 0 as  ChangePINStatus;
