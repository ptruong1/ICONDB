
CREATE PROCEDURE [dbo].[p_select_MessagesOfDay]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
	SELECT  [MessageID]
      ,[FacilityID]
      ,[Message]
      ,[PostBy]
      ,[ModifyBy]
      ,[PostDate]
      ,[ModifyDate]
      ,[FromDate]
      ,[ToDate]
  FROM [leg_Icon].[dbo].[tblFacilityOfficeMessage]
  where facilityID = @facilityID
