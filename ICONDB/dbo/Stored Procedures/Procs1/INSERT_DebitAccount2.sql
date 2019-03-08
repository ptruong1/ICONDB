
CREATE PROCEDURE [dbo].[INSERT_DebitAccount2]
(
	@InmateID varchar(12),
	@FacilityID int,
	@ActiveDate varchar(20),--  smalldatetime,
	@EndDate varchar(20), ---smalldatetime,
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
if (select count(*) from tblDebit with(nolock) where  InmateID = @InmateID and facilityID = @FacilityID ) = 0
begin
	declare  @i tinyint
	exec p_get_new_AccountNo  @AccountNo  OUTPUT
	set @i  = 1
	while @i = 1
	Begin
		select  @i = count(*) from tblDebit where Accountno = @AccountNo
		If  (@i > 0 ) 
		 Begin
			exec p_get_new_AccountNo  @AccountNo  OUTPUT
			SET @i = 1
		 end
	end 
	Declare  @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32) ;

       EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ; 
       
	INSERT INTO [tblDebit] ([RecordID],[InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
	VALUES (@ID, @InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())
	--INSERT INTO [tblDebit] ([InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
	--VALUES (@InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())

	set @accountNo = @ID

	EXEC  INSERT_ActivityLogs1   @FacilityID,9, 0,	@userName,'', @AccountNo
end
Else
 Begin
  Return -1
 End

