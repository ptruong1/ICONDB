
CREATE PROCEDURE  [dbo].[p_update_inmate_to_LA]
@PIN	varchar(12),
@InmateFirstName	varchar(25),
@InmateLastName	varchar(25),
@InmateStatus		tinyint,
@facilityID	int

 AS

If ( select count(*) from tblInmate   where PIN = @PIN  AND facilityID = @facilityID)  =0
 Begin
	Insert tblInmate (InmateID , PIN, firstName , LastName , Status,facilityID )  values( @PIN, @PIN, @InmateFirstName, @InmateLastName, @InmateStatus	, @facilityID)
	Return 0
 End
Else
 Begin
	if(@InmateStatus = 2) UPDATE  tblInmate   set Status =2   WHERE  PIN = @PIN  AND facilityID = @facilityID
 End



