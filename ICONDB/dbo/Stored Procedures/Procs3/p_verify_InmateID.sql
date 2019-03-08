CREATE PROCEDURE [dbo].[p_verify_InmateID]
@InmateID varchar(12),
@facilityID	int
 AS
 SET NOCOUNT ON;
If(select count(*)  from tblInmate with(nolock) where facilityID = @facilityID AND InmateID = @InmateID and status =1 ) > 0 
	select 1 as Status;
else
	select 0 as  Status;
