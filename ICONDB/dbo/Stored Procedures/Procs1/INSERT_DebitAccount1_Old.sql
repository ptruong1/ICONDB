
CREATE PROCEDURE [dbo].[INSERT_DebitAccount1_Old]
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
	@AccountNo  varchar(7)   OUTPUT,
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
	
	INSERT INTO [tblDebit] ([InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
	VALUES (@InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())
	

end
Else
 Begin
  Return -1
 End

