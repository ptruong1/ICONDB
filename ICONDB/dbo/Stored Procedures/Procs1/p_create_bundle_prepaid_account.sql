
CREATE PROCEDURE [dbo].[p_create_bundle_prepaid_account]
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
	
	INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@AccountNo ,@facilityID, getdate(), @balance,@balance,1, 'Process by Legacy', 'ptruong')
	SET @j = @j+1
  End

Select FacilityID,  Balance   from tblDebit  where  facilityID = @facilityID  AND inputdate >= convert (varchar(10), getdate(),101)

