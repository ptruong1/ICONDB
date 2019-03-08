
CREATE PROCEDURE [dbo].[p_private_inmate_info]
@PIN    varchar(10),
@facilityID int
 AS

select  BookingNo, ChargeCode,CaseNo, Bailout, BailAMount from tblInmateBookInfo where Pin = @PIN and facilityID = @facilityID;

