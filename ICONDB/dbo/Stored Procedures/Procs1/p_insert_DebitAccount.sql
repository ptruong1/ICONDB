
CREATE PROCEDURE [dbo].[p_insert_DebitAccount]
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
	@paymentTypeID	tinyint,
	@UserIP varchar(25)
	
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
	select @AccountNo
	--INSERT INTO [tblDebit] ([InmateID], [AccountNo], [FacilityID], [ActiveDate], [EndDate], [Balance], [ReservedBalance], [status], [Note], [UserName], [modifyDate]) 
	--VALUES (@InmateID,@AccountNo , @FacilityID, @ActiveDate, @EndDate, @Balance, @ReservedBalance, @status, @Note, @UserName, getdate())

	--Declare @UserAction  varchar(100),@ActTime datetime;
	--EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ; 
	
	--SET  @UserAction =  'Add/Edit Debit: ' + @AccountNo  ;
	--EXEC  INSERT_ActivityLogs3	@FacilityID ,9,@ActTime ,0,@UserName ,@UserIP, @AccountNo ,@UserAction ;
end
Else
 Begin
  Return -1
 End
