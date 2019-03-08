CREATE PROCEDURE [dbo].[p_update_register_inmate]
@facilityID	int,
@PIN		varchar(12)
 AS

Update	 tblInmate  set  NameRecorded = 1 where facilityID = @facilityID and PIN = @PIN
