-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_By_LocId]


@LocID int

AS
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	
	 begin
		SELECT [UserID]
      ,[ProfileID]
      ,[RemainEnrollments]
      ,[BioInmateID]
      ,[StationId]
      ,[LocId]
      ,[DivId]
      ,[RecordId]
  FROM [leg_Icon].[dbo].[tblBioMetricProfileOxfordIdentification]
  where locId = @locId
	 end
	


