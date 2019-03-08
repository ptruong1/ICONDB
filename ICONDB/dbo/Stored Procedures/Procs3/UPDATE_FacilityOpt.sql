
CREATE PROCEDURE [dbo].[UPDATE_FacilityOpt]
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
IF @facilityID in (SELECT facilityID FROM tblFacilityOption)
	BEGIN
	UPDATE [leg_Icon].[dbo].[tblFacilityOption]
	   SET 
		  [AccuPIN] = @AccuPIN
		  ,[BioMetric] = @BioMetric
		  ,[AutoPin] = @AutoPin
		  ,[NameRecord] = @NameRecord
		  ,[FormsOpt] = @FormsOpt
      
	WHERE FacilityID = @facilityID
	END
ELSE
	Begin
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
     End
     
