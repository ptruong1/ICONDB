

CREATE PROCEDURE [dbo].[UPDATE_VisitPhone_1107]
(
	 @facilityID int
    ,@StationID varchar(15)
    ,@RecordOpt varchar(1)
    ,@LimitTime int
    ,@UserName  varchar(25)
    ,@extID varchar(15)
    ,@PinRequired bit
    ,@LocationID int
    ,@LockDown bit
    ,@status tinyint
    ,@StationType tinyint

)
AS
	SET NOCOUNT OFF;

if (select count(*) from dbo.tblVisitPhone where ([extID] = @extID) and (facilityID = @facilityID) and (LocationID = @LocationID)) > 0
  UPDATE [tblVisitPhone] 
  SET [limitTime] = @LimitTime,
  [StationID] = @StationID,
  [UserName] = @UserName, 
  [ModifyDate] = getdate(),
  [RecordOpt] = @recordOpt, 
  [PinRequired] = @PinRequired,
  [LockDown] = @LockDown,
  [status] = @status,
  [StationType] = @StationType
  WHERE (
  ([extID] = @extID) and 
  (facilityID = @facilityID) and
  (LocationID = @LocationID)
  );
else
  INSERT INTO [leg_Icon].[dbo].[tblVisitPhone]
           ([ExtID]
           ,[StationID]
           ,[LocationID]
           ,[FacilityID]
           ,[RecordOpt]
           ,[LimitTime]
           ,[PinRequired]
           ,[LockDown] 
           ,[inputDate]
           ,[ModifyDate]
           ,[UserName]
           ,[status]
           ,[StationType])
     VALUES
           (@ExtID,
			@StationID, 
            @LocationID,
            @FacilityID,
            @RecordOpt,
            @LimitTime,
            @PinRequired,
            @LockDown,
            GETDATE(),
            Getdate(),
            @UserName,
            @status,
            @StationID)
           

