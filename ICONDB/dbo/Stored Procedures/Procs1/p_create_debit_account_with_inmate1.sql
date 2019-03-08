
CREATE PROCEDURE [dbo].[p_create_debit_account_with_inmate1]
@facilityID	int,
@InmateID	Varchar(12),
@firstName  varchar(25),
@lastName   varchar(25),
@balance	numeric(5,2),
@Processby  varchar(20),
@AccountNo varchar(12) OUTPUT
AS

declare  @i tinyint, @purchaseID bigint , @lastBalance numeric(6,2);
Declare @return_value int, @nextID bigint, @ID bigint, @tblDebit nvarchar(32),@tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;
SET @AccountNo='0' ;
Select @AccountNo= AccountNo,@lastBalance = Balance  from tblDebit where InmateID = @InmateID and facilityID = @FacilityID ;

if(@InmateID ='' or @InmateID is null)
	SET @InmateID='0'; 
 
  
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

       EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ;   
	INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@ID, @AccountNo ,@facilityID,@inmateID, getdate(), @balance,@balance,1, @Processby, 'ClientInput');
 End
Else
    Update [tblDebit] SET Balance = balance + @balance, status=1 where AccountNo = @AccountNo;
if(select count(*) from tblinmate where facilityID = @facilityID and InmateID = @inmateID) =0
	insert tblInmate(inmateID, pin, facilityID, [status], FirstName, LastName,inputDate)
								values (@inmateID,@inmateID,@facilityID,1,@firstName,@lastName,getdate())    ;
								
 EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;   
INSERT INTO tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID,@AccountNo , getdate(), @Processby);
		SET @purchaseID =@ID;
		
INSERT INTO  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2,@balance)

 EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
       set           @ID = @nextID ; 
INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName, PaymentDate, PurchaseNo,LastBalance   )
					        Values(@ID,@AccountNo, @FacilityID, @inmateID, @balance , 7,  @Processby, getdate(), @purchaseID, @LastBalance)	;							
 


--declare  @i tinyint, @purchaseID bigint , @lastBalance numeric(6,2);
--SET @AccountNo='0' ;
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
--	VALUES (@AccountNo ,@facilityID,@inmateID, getdate(), @balance,@balance,1, @Processby, 'ClientInput');
-- End
--Else
--    Update [tblDebit] SET Balance = balance + @balance, status=1 where AccountNo = @AccountNo;
--if(select count(*) from tblinmate where facilityID = @facilityID and InmateID = @inmateID) =0
--	insert tblInmate(inmateID, pin, facilityID, [status], FirstName, LastName,inputDate)
--								values (@inmateID,@inmateID,@facilityID,1,@firstName,@lastName,getdate())    ;
								

--INSERT INTO tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @Processby);
--		SET @purchaseID =SCOPE_IDENTITY();
--INSERT INTO  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2,@balance)

--INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName, PaymentDate, PurchaseNo,LastBalance   )
--					        Values(@AccountNo, @FacilityID, @inmateID, @balance , 7,  @Processby, getdate(), @purchaseID, @LastBalance)	;							
 

