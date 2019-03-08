-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_Inmate_FormConfig]
(
	@InmateID varchar(12),
	@FormType tinyint,
	@FacilityId int
)
AS
	SET NOCOUNT ON;
	if (select count(*) FROM [leg_Icon].[dbo].[tblFormInmateConfig] C WHERE C.InmateID = @InmateID AND  C.FacilityId = @FacilityId and C.FormType = @FormType) > 0
	begin
	SELECT [FacilityID]
		  ,[InmateID]
		  ,[FormType]
		  ,isnull(PerDay,1) as PerDay
		  ,isnull(PerWeek,7) as PerWeek
		  ,Isnull(PerMonth,30) as PerMonth
		  ,[UserNote] as Note
	  FROM [leg_Icon].[dbo].[tblFormInmateConfig] C
					
		WHERE C.InmateID = @InmateID AND  C.FacilityId = @FacilityId and C.FormType = @FormType
	end
	Else
	SELECT [FacilityID]
		,'' as [InmateID]
      ,[FormTypeID]
      ,isnull(PerDay,1) as PerDay
		  ,isnull(PerWeek,7) as PerWeek
		  ,Isnull(PerMonth,30) as PerMonth
		  ,'' as Note
      
  FROM [leg_Icon].[dbo].[tblFormFacilityConfig] C
  WHERE  C.FacilityId = @FacilityId and C.FormTypeID = @FormType

