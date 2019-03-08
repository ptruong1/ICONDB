


CREATE PROCEDURE [dbo].[Insert_VisitPhone]
(
	 @facilityID int
    ,@StationID varchar(15)
    ,@RecordOpt varchar(1)
    ,@LimitTime int
    ,@UserName  varchar(25)
    ,@extID varchar(15)
    ,@PinRequired bit
    ,@LocationID int

)
AS
	SET NOCOUNT OFF;


  INSERT INTO [leg_Icon].[dbo].[tblVisitPhone]
           ([ExtID]
           ,[StationID]
           ,[LocationID]
           ,[FacilityID]
           ,[RecordOpt]
           ,[LimitTime]
           ,[PinRequired]
           ,[inputDate]
           ,[ModifyDate]
           ,[UserName])
     VALUES
           (@ExtID,
			@StationID, 
            @LocationID,
            @FacilityID,
            @RecordOpt,
            @LimitTime,
            @PinRequired,
            GETDATE(),
            Getdate(),
            @UserName)
           


