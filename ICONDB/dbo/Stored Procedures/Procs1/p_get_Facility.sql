
CREATE PROCEDURE [dbo].[p_get_Facility] 
@State		char(2),
@trunkNo	varchar(4)


 AS

SELECT  FacilityID,  Location from tblFacilityService with(nolock) where  state = @state  and trunkNo = @trunkNo

