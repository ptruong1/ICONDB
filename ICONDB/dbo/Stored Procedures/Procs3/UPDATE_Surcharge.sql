
CREATE PROCEDURE [dbo].[UPDATE_Surcharge]
(
	@SurchargeID varchar(5),
	@Descript varchar(50)
		
)
AS
	SET NOCOUNT OFF;
UPDATE [tblSurcharge] SET  [Descript] = @Descript WHERE (([SurchargeID] = @SurchargeID));
	
SELECT SurchargeID, Descript FROM tblSurcharge WHERE (SurchargeID = @SurchargeID)

