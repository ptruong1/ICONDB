
CREATE PROCEDURE [dbo].[p_commissary_fund_Debit_restfull]

@Token varchar(40),
@ClientInmateAcct varchar(16),
@ClientTransID	varchar(30),
@Amount numeric(7,2)

AS

declare  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Replystatus varchar(2), @LastBalance numeric(5,2),  @DebitStatus tinyint,
@UserName varchar(20), @return_Message varchar(50), @InmateID varchar(12), @return_code char(1) , @Amount_v varchar(10) ;
 Declare @return_value int, @nextID bigint, @ID bigint, @tblpurchase nvarchar(32),@tblDebitPayments nvarchar(32), @tblDebit nvarchar(32) ;
SET @facilityID =0;

--if(CHARINDEX('-',@ClientInmateAcct,1) >0)
--	set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) )) ;
--else
--	set @InmateID = @ClientInmateAcct;

--SET @InmateID = replace (@ClientInmateAcct,'-','');
set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) ))
set @return_Message = 'Invalid token' ;
SET  @return_code='1' ; 
SET  @DebitStatus =0;
select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 begin
	Select @AccountNo= AccountNo,@lastBalance = Balance, @DebitStatus =status  from tblDebit where  facilityID = @FacilityID and InmateID = @InmateID  ;
	if (@DebitStatus >0)
	 Begin
		  UPDATE [dbo].[tblDebit]  SET  [Balance] = Balance + @amount, status=1, modifyDate=getdate(),UserName=@UserName  where AccountNo=@AccountNo;
		  SET @return_Message = 'Complete Successfull';
		  SET  @return_code='0' ; 		  
     end
   else
    begin
		 if(select count(*) from tblinmate where facilityID = @facilityID and InmateID = @InmateID) >0
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
				set           @ID = @nextID ;  
				INSERT INTO [tblDebit] ([RecordID] ,[AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
				VALUES (@ID, @AccountNo ,@facilityID,@InmateID,  getdate(), @Amount,@Amount,1, '',  @userName);

				--INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
				--VALUES (@AccountNo ,@facilityID,@InmateID, getdate(), @Amount,@Amount,1, '', @userName);
				SET @return_Message = 'Complete Successfull';
				SET  @return_code='0' ;
		  End
		else
		 Begin
			SET  @return_code='1' ;
			SET @return_Message = 'Incompleted, account not found'; 
		 end
	 end
	 if(@@ERROR =0)
	 begin
		if( @Replystatus='0')
			 Insert tblDebitCardOrder(OrderNo,FacilityID,InmateID,Amount,clientID )
					 values(@ClientTransID,@FacilityID,@InmateID,@Amount, @userName);
			EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
		   set           @ID = @nextID ;  
			Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @userName)

			--INSERT INTO tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(),@userName);

			SET @transaction_id =@ID;

			INSERT INTO  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values(@transaction_id, 2, 2,@Amount);

			EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
       set           @ID = @nextID ; 
		INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName, PaymentDate, PurchaseNo,LastBalance   )
					        Values(@ID,@AccountNo, @FacilityID, @inmateID, @Amount , 7,  @UserName, getdate(), @transaction_id, @LastBalance)	;

			--INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName, PaymentDate, PurchaseNo,LastBalance   )
			--							Values(@AccountNo, @FacilityID, @InmateID, @Amount , 7,  @UserName, getdate(), @transaction_id, @LastBalance);
	 end
	else
	 begin
		SET  @return_code='1' ;
		SET @return_Message = 'Incompleted, account not found'; 
	 end
 end
 --- Log API call
 SET @Amount_v  = CAST(@Amount as varchar(10))
 EXEC p_API_call  @ClientTransID ,'Token'	,@userName	,@facilityID ,@userName	,@InmateID	,''		,'' ,2, @Amount_v

 select   @return_code as return_code
		  ,@return_Message return_message
		  ,@ClientInmateAcct as account_number
		  ,@ClientTransID as trans_id
		  ,@transaction_id as transaction_id ;
 						
