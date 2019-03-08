


CREATE PROCEDURE [dbo].[INSERT_FacilityOpt]
(
			@FacilityID int
           ,@AccuPIN bit
           ,@BioMetric bit
           ,@AutoPin tinyint
           ,@NameRecord bit
           ,@FormsOpt bit
)
AS
	SET NOCOUNT OFF;

INSERT INTO [leg_Icon].[dbo].[tblFacilityOption]
           ([FacilityID]
           ,[AccuPIN]
           ,[BioMetric]
           ,[AutoPin]
           ,[NameRecord]
           ,[FormsOpt]
           )
     VALUES
           (@FacilityID
           ,@AccuPIN
           ,@BioMetric
           ,@AutoPin
           ,@NameRecord
           ,@FormsOpt
           )

