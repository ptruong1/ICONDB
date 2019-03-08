
CREATE PROCEDURE [dbo].[p_create_bundle_prepaid_account1]
@facilityID	int,
@Num		int,
@balance	numeric(5,2)
AS


declare  @i tinyint, @j int, @AccountNo varchar(12)
SET @j =0
while @j <@Num
 Begin
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
	Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32),@tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;
	EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ;   
	INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@ID, @AccountNo ,@facilityID,"", getdate(), @balance,@balance,1, 'Process by Legacy', 'ptruong');

	--INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	--VALUES (@AccountNo ,@facilityID, getdate(), @balance,@balance,1, 'Process by Legacy', 'ptruong')

	SET @j = @j+1
  End

Select FacilityID, ('# ' +  AccountNo) as AccountNo, Balance, ReservedBalance, ActiveDate   from tblDebit  where  facilityID = @facilityID  AND inputdate >= convert (varchar(10), getdate(),101)

