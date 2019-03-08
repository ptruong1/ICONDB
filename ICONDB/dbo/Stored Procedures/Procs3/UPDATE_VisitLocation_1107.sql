

CREATE PROCEDURE [dbo].[UPDATE_VisitLocation_1107]
(
	 @LocationName varchar(35)
    ,@LocationIP varchar(15)
    ,@FacilityID int
    ,@userName varchar(25)
    ,@LimitTime int
    ,@LocationID int
    ,@LockDown bit
)
AS
	SET NOCOUNT OFF;

if (select count(*) from dbo.tblVisitLocation where ([LocationID] = @LocationID)) > 0
  UPDATE [tblVisitLocation] SET 
  [LocationName] = @LocationName, [limitTime] = @LimitTime, [LockDown] = @LockDown, [UserName] = @UserName, [ModifyDate] = getdate() WHERE (([LocationID] = @LocationID));
else
  INSERT INTO [leg_Icon].[dbo].[tblVisitLocation]
           ([LocationName]
           ,[LocationIP]
           ,[FacilityID]
           ,[LockDown] 
           ,[inputDate]
           ,[ModifyDate]
           ,[userName]
           ,[LimitTime])
     VALUES
           (@LocationName
           ,@LocationIP
           ,@FacilityID
           ,@LockDown
           ,getdate()
           ,getdate()
           ,@userName
           ,@LimitTime)
           

