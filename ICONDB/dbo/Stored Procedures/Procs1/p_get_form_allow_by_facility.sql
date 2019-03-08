-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_form_allow_by_facility]
(
	
	@FacilityId int

)
AS
	SET NOCOUNT ON;
Declare @t table (id int, FormName varchar(20));
   insert @t
	SELECT 1, 'Inmate Kite' FROM [leg_Icon].[dbo].[tblFacilityForms] 
   where inmateKite = 1 and facilityID = @facilityID
   insert @t
	SELECT 2, 'Medical Kite' FROM [leg_Icon].[dbo].[tblFacilityForms] 
   where medicalKite = 1 and facilityID = @facilityID
   insert @t
	SELECT 3, 'Grievance Forms' FROM [leg_Icon].[dbo].[tblFacilityForms] 
   where Grievance = 1 and facilityID = @facilityID
   insert @t
	SELECT 4, 'Legal Forms' FROM [leg_Icon].[dbo].[tblFacilityForms] 
   where LegalForm = 1 and facilityID = @facilityID

   select * from @t
