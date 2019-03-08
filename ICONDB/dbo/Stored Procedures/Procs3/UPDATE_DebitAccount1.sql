﻿
CREATE PROCEDURE [dbo].[UPDATE_DebitAccount1]
(
	@AccountNo Varchar(12),
	@InmateID Varchar(12),
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

If (select count(*) from tblUserProfiles with(nolock) Where Userlevel = 1) = 1
	UPDATE [tblDebit] SET [InmateID] = @InmateID,
						[FacilityID] = @FacilityID,
						[ActiveDate] = @ActiveDate,
						[EndDate] = @EndDate,
						[Balance] = @Balance,
						--[ReservedBalance] = @ReservedBalance,
						[status] = @status,
						[Note] = @Note,
						[UserName] = @UserName,
						[modifyDate] = getdate()
	WHERE AccountNo = @AccountNo AND FacilityID = @FacilityID
Else
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
