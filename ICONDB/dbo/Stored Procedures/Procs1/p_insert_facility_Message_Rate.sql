CREATE PROCEDURE [dbo].[p_insert_facility_Message_Rate]  -- Family send Email to Inmate Email Box
@facilityID int
      ,@MessageTypeId int
      ,@Charge numeric(6,2)
      ,@ChargePerTrans numeric(6,2)
      ,@Comm numeric(6,2)
      ,@UserName varchar(25)
AS
Begin
	INSERT INTO [leg_Icon].[dbo].[tblMessageRate]
           ([FacilityID]
           ,[MessageTypeID]
           ,[Charge]
           ,[ChargePerTrans]
           ,[Comm]
           ,[InputDate]
           ,[UserName])
     VALUES
           (@facilityID
           ,@MessageTypeID
           ,@Charge
           ,@ChargePerTrans
           ,@Comm / 100
           ,GETDATE()
           ,@UserName)

End;

