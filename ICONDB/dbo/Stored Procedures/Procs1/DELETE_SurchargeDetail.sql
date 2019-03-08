

CREATE PROCEDURE [dbo].[DELETE_SurchargeDetail]
(
	@SurchargeID varchar(5)
   ,@state char(2)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [leg_Icon].[dbo].[tblSurchargeDetail]
      WHERE  SurchargeID = @SurchargeID and State = @State

