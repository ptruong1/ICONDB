
CREATE PROCEDURE [dbo].[p_get_TTYPhone]
@FacilityId	int,
@Phones      char(10)  OUTPUT
 AS

select @Phones =  TTYphone from tblTTYphones where  facilityID =@FacilityId

