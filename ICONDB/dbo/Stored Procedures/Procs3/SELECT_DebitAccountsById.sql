
CREATE PROCEDURE [dbo].[SELECT_DebitAccountsById]
(
	@FacilityID int,
	@InmateID  varchar(12)
)
AS
	SET NOCOUNT ON;

If (@facilityID > 0) 

	SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [inputdate], [modifyDate], [Username]
	FROM tblDebit   with(nolock)
	WHERE FacilityID = @FacilityID AND InmateID = @InmateID
Else
	SELECT  [AccountNo], [InmateID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [inputdate], [modifyDate], [Username]
	FROM tblDebit   with(nolock)
	WHERE  InmateID = @InmateID

