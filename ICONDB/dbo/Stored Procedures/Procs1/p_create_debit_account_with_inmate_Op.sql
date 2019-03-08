
CREATE PROCEDURE [dbo].[p_create_debit_account_with_inmate_Op]
@facilityID	int,
@InmateID	Varchar(12),
@firstName  varchar(25),
@lastName   varchar(25),
@balance	numeric(7,2),
@Processby  varchar(20),
@AccountNo varchar(12) OUTPUT,
@lastBalance numeric(7,2) OUTPUT
AS

declare  @i tinyint ;
SET @AccountNo='0' ;
SET @lastBalance =0;
Select @AccountNo= AccountNo,@lastBalance = Balance  from tblDebit where InmateID = @InmateID and facilityID = @FacilityID ;
if(@AccountNo='0')
 Begin
	exec p_get_new_AccountNo  @AccountNo  OUTPUT;
	set @i  = 1;
	while @i = 1
	 Begin
		select  @i = count(*) from tblDebit where Accountno = @AccountNo;
		If  (@i > 0 ) 
		 Begin
			exec p_get_new_AccountNo  @AccountNo  OUTPUT;
			SET @i = 1;
		 end
	 end 
      Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32) ;
       EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ;      
	INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@ID, @AccountNo ,@facilityID,@inmateID, getdate(), @balance,@balance,1, @Processby, @Processby);
 End
Else
    Update [tblDebit] SET Balance = balance + @balance, status=1 where AccountNo = @AccountNo;
	
--declare  @i tinyint ;
--SET @AccountNo='0' ;
--SET @lastBalance =0;
--Select @AccountNo= AccountNo,@lastBalance = Balance  from tblDebit where InmateID = @InmateID and facilityID = @FacilityID ;
--if(@AccountNo='0')
-- Begin
--	exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--	set @i  = 1;
--	while @i = 1
--	 Begin
--		select  @i = count(*) from tblDebit where Accountno = @AccountNo;
--		If  (@i > 0 ) 
--		 Begin
--			exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--			SET @i = 1;
--		 end
--	 end 

--	INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
--	VALUES (@AccountNo ,@facilityID,@inmateID, getdate(), @balance,@balance,1, @Processby, @Processby);
-- End
--Else
--    Update [tblDebit] SET Balance = balance + @balance, status=1 where AccountNo = @AccountNo;
								
