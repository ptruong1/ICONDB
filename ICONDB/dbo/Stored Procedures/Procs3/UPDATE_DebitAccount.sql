
CREATE PROCEDURE [dbo].[UPDATE_DebitAccount]
(
	@AccountNo bigint,
	@InmateID varchar(12),
	@FacilityID int,
	@ActiveDate smalldatetime,
	@EndDate smalldatetime,
	@Balance numeric(7,2),
	@ReservedBalance numeric(7,2),
	@status tinyint,
	@Note varchar(50),
	@UserName varchar(25)
)

AS


SET NOCOUNT OFF;
UPDATE [tblDebit] SET [InmateID] = @InmateID,
					[FacilityID] = @FacilityID,
					[ActiveDate] = @ActiveDate,
					[EndDate] = @EndDate,
					--[Balance] = @Balance,
					--[ReservedBalance] = @ReservedBalance,
					[status] = @status,
					[Note] = @Note,
					[UserName] = @UserName,
					[modifyDate] = getdate()
WHERE AccountNo = @AccountNo AND FacilityID = @FacilityID

EXEC  INSERT_ActivityLogs1   @FacilityID,9, 0,	@userName,'', @AccountNo
