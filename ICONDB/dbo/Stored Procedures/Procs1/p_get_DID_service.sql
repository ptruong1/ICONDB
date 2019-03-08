
CREATE PROCEDURE [dbo].[p_get_DID_service]
@facilityID	int,
@DID		char(10) OUTPUT 
 AS

select   @DID	= DID FROM  tblFacilityService with(nolock)  WHERE FacilityID =@facilityID

