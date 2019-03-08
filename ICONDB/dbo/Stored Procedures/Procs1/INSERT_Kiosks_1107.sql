


CREATE PROCEDURE [dbo].[INSERT_Kiosks_1107]
(
	@FacilityID int,
	@LocationID int,
	@ExtID char(15),
	@StationID varchar(50),
	@LimitTime int,
	@PINRequired bit,
	@RecordOpt char(1),
	@UserName varchar(25),
	@ChatRoomID varchar(25),
	@LockDown bit,
	@status tinyint,
	@StationType tinyint
	
)
AS
	SET NOCOUNT OFF;

if (select count(*) from dbo.tblVisitPhone where ([extID] = @extID) and (facilityID = @facilityID) and (LocationID = @LocationID)) > 0
	BEGIN
		RETURN -1;
	END
ELSE
	BEGIN
		INSERT INTO [tblVisitPhone] 
		(
		[FacilityID], 
		[LocationID], 
		[ExtID], 
		[StationID], 
		LimitTime, 
		[PINRequired], 
		RecordOpt, 
		[UserName], 
		[modifyDate], 
		[ChatRoomID], 
		[LockDown],
		[status],
		[StationType]
		) 
		VALUES (
		@FacilityID,  
		@LocationID, 
		@ExtID, 
		@StationID, 
		@LimitTime, 
		@PINRequired, 
		@RecordOpt,  
		@UserName, 
		getdate(), 
		@ChatRoomID, 
		@LockDown,
		@status,
		@StationType
		);
		RETURN 0;
	END

