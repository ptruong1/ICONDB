

CREATE PROCEDURE [dbo].[p_UPDATE_Facility_Message_Rate]
(
	@facilityID int
      ,@MessageTypeId int
      ,@Charge numeric(6,2)
      ,@ChargePerTrans numeric(6,2)
      ,@Comm numeric(6,2)
      ,@UserName varchar(25)
)
AS
	SET NOCOUNT OFF;
	UPDATE [leg_Icon].[dbo].[tblMessageRate]
   SET Charge = @Charge
      ,[ChargePerTrans] = @ChargePerTrans
      ,[Comm] = @Comm / 100
      ,[ModifyDate] = GETDATE()
      ,[UserName] = @UserName
 WHERE facilityID = @facilityID and
 MessageTypeID = @MessageTypeID

