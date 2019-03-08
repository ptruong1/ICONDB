
CREATE PROCEDURE [dbo].[INSERT_VisitRate]
(
			@RateID varchar(7)
           ,@PerMinCharge numeric(4,2)
           ,@ConnectFee numeric(4,2)
           ,@Descript varchar(20)
           ,@VisitType tinyint
           ,@Increment tinyint
           ,@CommRate numeric(4,2)
	
)
AS
	SET NOCOUNT OFF;
	IF (SELECT Count( RateID)  FROM tblVisitRate WHERE RateID = @RateID  and VisitType = @VisitType)  >0
	UPDATE [leg_Icon].[dbo].[tblVisitRate]
   SET 
      [PerMinCharge] = @PerMinCharge
      ,[ConnectFee] = @ConnectFee
      ,[Descript] = @Descript
      ,[Increment] = @Increment
      ,[CommRate] = @CommRate
  WHERE RateID = @RateID  and VisitType = @VisitType
 else
	INSERT INTO [leg_Icon].[dbo].[tblVisitRate]
           ([RateID]
           ,[PerMinCharge]
           ,[ConnectFee]
           ,[Descript]
           ,[VisitType]
           ,[Increment]
           ,[CommRate])
     VALUES
           (@RateID
           ,@PerMinCharge
           ,@ConnectFee
           ,@Descript
           ,@VisitType
           ,@Increment
           ,@CommRate)

