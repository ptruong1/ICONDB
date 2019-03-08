CREATE PROCEDURE [dbo].[p_create_Debit_onetime]
(
	@InmateID varchar(12),
	@FacilityID int,
	@ActiveDate smalldatetime,
	@EndDate smalldatetime,
	@Balance numeric(7,2),
	@ReservedBalance numeric(7,2),
	@status tinyint,
	@Note varchar(50),
	@UserName varchar(25), 
	@AccountNo  varchar(12)   OUTPUT,
	@paymentTypeID	tinyint
	
)

AS

SET NOCOUNT OFF;

Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32) ;
if(@InmateID ='' or @InmateID is null)
	SET @InmateID='0';
EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
set           @ID = @nextID ;      
INSERT INTO [tblDebit] ([RecordID], [InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
VALUES (@ID, @InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())
	
--INSERT INTO [tblDebit] ([InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
--VALUES (@InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())

