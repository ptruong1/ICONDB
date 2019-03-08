

CREATE PROCEDURE [dbo].[Insert_VisitLocation_1107]
(
	 @LocationName varchar(35)
    ,@LocationIP varchar(15)
    ,@FacilityID int
    ,@userName varchar(25)
    ,@LimitTime int
    ,@LockDown bit
    
)
AS
	SET NOCOUNT OFF;
	Declare  @return_value int, @nextID int, @ID int, @tblVisitLocation nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblVisitLocation', @nextID   OUTPUT
    set           @ID = @nextID ;    
  INSERT INTO [tblVisitLocation]
           (LocationID
           ,[LocationName]
           ,[LocationIP]
           ,[FacilityID]
           ,[inputDate]
           ,[ModifyDate]
           ,[userName]
           ,[LockDown]
           ,[LimitTime])
     VALUES
           (@ID
           ,@LocationName
           ,@LocationIP
           ,@FacilityID
           ,getdate()
           ,getdate()
           ,@userName
           ,@LockDown
           ,@LimitTime)

  --INSERT INTO [leg_Icon].[dbo].[tblVisitLocation]
  --         ([LocationName]
  --         ,[LocationIP]
  --         ,[FacilityID]
  --         ,[inputDate]
  --         ,[ModifyDate]
  --         ,[userName]
  --         ,[LockDown]
  --         ,[LimitTime])
  --   VALUES
  --         (@LocationName
  --         ,@LocationIP
  --         ,@FacilityID
  --         ,getdate()
  --         ,getdate()
  --         ,@userName
  --         ,@LockDown
  --         ,@LimitTime)
           
