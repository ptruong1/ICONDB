-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE p_get_facilityForm_status  --- Assign status enum 
@FacilityFormID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select statusID, Descript as statusName from tblFormstatus where FacilityFormID= @FacilityFormID;
End
 
