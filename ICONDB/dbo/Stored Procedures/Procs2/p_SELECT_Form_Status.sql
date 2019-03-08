

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_Form_Status] 
(
	@facilityID int
   ,@FormType int
)
AS
	SET NOCOUNT ON;

	Declare @ID int
	
	set @ID = (Select Template from [leg_Icon].[dbo].[tblFacilityForms] where facilityID = @facilityID)
	--If @facilityid in (2, 558, 574, 578, 585, 684, 691) 
	--   set @ID = 0
	--else
	--	set @ID = 796
	--;
	BEGIN
	If @ID = 796
	begin
		if @formType = 1
			begin
				SELECT [statusID]
				  ,[Descript]
				  FROM [leg_Icon].[dbo].[tblFormstatus]
				  where facilityFormID = @ID
					and StatusID in (20, 52, 53)
			End
		else
		if @formType in (2, 4)
			begin
				SELECT [statusID]
				  ,[Descript]
				  FROM [leg_Icon].[dbo].[tblFormstatus]
				  where facilityFormID = @ID
					and StatusID in (20, 55)
			End
		else -- formtype 4 Grievance
			begin
				SELECT [statusID]
				  ,[Descript]
				  FROM [leg_Icon].[dbo].[tblFormstatus]
				  where facilityFormID = @ID
					and StatusID not in (52, 53, 55)	
			End
	End

else
begin
IF @FormType = 3
	BEGIN
		SELECT [statusID]
      ,[Descript]
		FROM [leg_Icon].[dbo].[tblFormstatus]
		where facilityFormID = @ID
	END
ELSE
	BEGIN
		SELECT  [statusID]
      ,[Descript]
  FROM [leg_Icon].[dbo].[tblFormstatus]
  where statusID = 1 or statusID = 2 or statusID = 15
  and facilityFormID = @ID
	END 
End
End
