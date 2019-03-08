-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_export_inmate_list_by_facility_for_edovo]
@facilityID int	
AS
BEGIN

Declare @cmd  varchar(500),@file_dir   varchar(200),@FileName varchar(50),@file_out varchar(200);

select   InmateID as XREF,LastName ,firstName,  isnull(left(MidName,1),'') MiddleInit , isnull(DOB,'') as DOB, FacilityId , '' Area ,'' Pod,  isnull(Sex,'') as Sex , 
'' Race, '' ProjectedReleas from leg_Icon.dbo.tblInmate where  FacilityId = @facilityID and Status=1 and InmateID >'0';

--select   InmateID as XREF,LastName ,firstName,  left(MidName,1) MiddleInit , isnull(DOB,'') as DOB, FacilityId , Null Area ,Null Pod,  
--Sex , Null Race, Null ProjectedReleas from leg_Icon.dbo.tblInmate where  FacilityId =@facilityID and Status=1 and InmateID >'0';
	
	
return @@error

END

