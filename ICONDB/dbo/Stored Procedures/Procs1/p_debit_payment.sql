CREATE PROCEDURE [dbo].[p_debit_payment]
@FacilityID int,
@InmateID varchar(12),
@PurchaseAmount    numeric(7,2) ,   
@ProcessFee	    numeric(7,2) ,  
@Tax		      numeric(7,2),  
@PaymentTypeID  int , 
@checkNo	VARCHAR(10), 
@ccNo		VARCHAR(16),
@ccExp	VARCHAR(4),
@ccCVV	VARCHAR(4)	,
@BillPhoneNo		VARCHAR(10),
@BilltoFirstName	VARCHAR(20)	, 
@BillToLastName	VARCHAR(20),  
@BillToEmail	varchar(30),
@BillToAddress	varchar(50),
@BillToCity	varchar(30),
@BillToZip		VARCHAR(5), 
@BillToState	varchar(2),
@BillToCountry	varchar(30),
@TerminalID	VARCHAR(20),
@UserName	VARCHAR(20)

AS
SET NoCount ON
if((@checkNo = '')or(@checkNo is null)or(@checkNo = 'null')or(ISNUMERIC(@checkNo) = 0 )) set @checkNo = '0'

declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2), @AccountNo varchar(12), @NewBalance numeric(6,2) ;
Declare @return_value int, @nextID bigint, @ID bigint, @tblDebitpayments nvarchar(32), @tblTransactionLogs nvarchar(32),@tblpurchase nvarchar(32),@tblWUPrepaid nvarchar(32);
SET  @authAmount = @PurchaseAmount + @ProcessFee + @tax ;
SET  @LastBalance  = 0;
SET @AccountNo='0';
SELECT  @LastBalance =  balance, @AccountNo=AccountNo  From tblDebit where  InmateID= @InmateID and FacilityID= @facilityID ;
SET  @NewBalance = @LastBalance  + @PurchaseAmount;

if(@AccountNo='0')
 Begin
	declare @i int;
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
       set   @ID = @nextID ;      
	INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@ID, @AccountNo ,@facilityID,@inmateID, getdate(),@PurchaseAmount  ,@PurchaseAmount ,1, '',@UserName);
 End
Else
 begin
	if (@paymentTypeID <> 4)
		UPDATE tblDebit  Set Balance = Balance + @PurchaseAmount ,  ModifyDate = getdate()  where AccountNo =@AccountNo;
 end
if (@paymentTypeID = 4)
 Begin
   	if(select count(*) from  tblWUPrepaid  where CustAcctNo =@BillPhoneNo ) = 0
   			EXEC   @return_value = p_create_nextID 'tblWUPrepaid', @nextID   OUTPUT;
        set           @ID = @nextID ;   
		insert tblWUPrepaid(CustSeqNo,  CustAcctNo,FirstName ,LastName ,Address,City , State, Zip ,Country, Phone,ProcessType,  FacilityID,	   UploadFTP, DownLoadFTP )
		values(@ID, @BillPhoneNo ,@BilltoFirstName	,@BilltoLastName  ,left(@BillToAddress,40) ,@BillToCity , @billToState, @BillToZip,@BillToCountry,@AccountNo ,'A',  @facilityID,	  0, 0) ;

 End
Else
 Begin
	    EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT;
        SET @purchaseID = @nextID;
		Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@purchaseID, @AccountNo , getdate(), @TerminalID);
		
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax);
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee);
	
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);
			

        EXEC   @return_value = p_create_nextID 'tblDebitpayments', @nextID   OUTPUT;
        set           @ID = @nextID ;    
		INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo,LastBalance )
					        Values(@ID,@AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @checkno,'', @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@userName, getdate(), @purchaseID, @LastBalance);
	
 End

 	Select @InmateID as InmateID, @LastBalance as lastBalance, @NewBalance as Balance , 1 as Success, '010' as ResponseCode,  @purchaseID as ConfirmID;
