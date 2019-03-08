
CREATE PROCEDURE [dbo].[p_commissary_deposit_debit_account]
@RequestID varchar(22),
@ClientType	varchar(16),  -- not use
@SystemID	varchar(12)	,			--ClientID
@SystemTag varchar(12),  -- facilityID	int,
@Vendor	varchar(12), --Swandons
@ResidentIdentifier	varchar(12),-- InmateID	Varchar(12),
@PIN		varchar(12),
@Amount  varchar(10),
@TimeStamp  varchar(30),
@IPaddress varchar(16)
AS

declare  @i tinyint, @purchaseID bigint , @lastBalance numeric(6,2),@AccountNo varchar(12),@FacilityID int, @AmountDeposit numeric(6,2), @transCount smallint  ;

declare @Replystatus varchar(2), @CurrentDate datetime, @inmateStatus tinyint, @DebitStatus tinyint;
Declare @return_value int, @nextID bigint, @ID bigint, @tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;
SET  @transCount =0;
if (isnumeric(@SystemTag) =0)
	SET @Replystatus='3'; 
else
begin
	SET @FacilityID = cast(@SystemTag  as int);
	SET @inmateStatus = 0;
	SET @DebitStatus =0;
	SET @AccountNo='0' ;
	SET @Replystatus ='0';
	SET @Replystatus= dbo.fn_verify_commissary_client(@ClientType,@FacilityID,@SystemID) ;
	SET @AmountDeposit = CAST (@Amount  as numeric(6,2));
	SET @CurrentDate = getdate();
end
if( @Replystatus='0')
begin
	if(@FacilityID =784)
	 Begin
		SET @ResidentIdentifier = left(@ResidentIdentifier,len(@ResidentIdentifier)-4);
	 end
	select @inmateStatus = status from  tblinmate with(nolock) where facilityID = @FacilityID and InmateID =@ResidentIdentifier ;
	if(@FacilityID not in (702, 786,1, 756))		 --- Exception
			SET @PIN = @ResidentIdentifier  + @PIN;
	
	if(@inmateStatus=0) 
	 begin
		
		Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate, InmateNote, modifyDate)
					values(@FacilityID ,@ResidentIdentifier , 1,'NA' , 'NA' ,@PIN, @CurrentDate, @PIN,@CurrentDate  );
	 end
	else
	 begin
		update tblinmate set status =1  where facilityID = @FacilityID and InmateID =@ResidentIdentifier ;
	 end 
	 
	Select @AccountNo= AccountNo,@lastBalance = Balance, @DebitStatus =status  from tblDebit where  facilityID = @FacilityID and InmateID = @ResidentIdentifier  ;
	if(@DebitStatus =0)
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
		INSERT INTO [tblDebit] ([RecordID] ,[AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
		VALUES (@ID, @AccountNo ,@facilityID,@ResidentIdentifier,  @CurrentDate, @AmountDeposit,@AmountDeposit,1, @Vendor, 'Commissary');

		--INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
		--VALUES (@AccountNo ,@facilityID,@ResidentIdentifier, @CurrentDate, @AmountDeposit,@AmountDeposit,1, @Vendor, 'Commissary');
	 End
	 Else
	  begin
			select @transCount = count(*) from tblDebitCardOrder where FacilityID=@FacilityID and OrderNo= @RequestID;
			if(@transCount =0)
				Update tblDebit set Balance = Balance + @AmountDeposit, modifyDate= @CurrentDate, status=1 where AccountNo = @AccountNo;
	  end
 end

--EXEC p_API_call  @RequestID ,@ClientType	,@SystemID	,@SystemTag ,@Vendor	,@ResidentIdentifier	,@PIN		,@IPaddress ,2,@Amount

if(@@ERROR =0)
 begin
	if( @Replystatus='0')
	 begin
		if(@transCount =0)
		   begin
				 Insert tblDebitCardOrder(OrderNo,FacilityID,InmateID,Amount,clientID )
						 values(@RequestID,@FacilityID,@ResidentIdentifier,@Amount, @ClientType );

				EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
				   set           @ID = @nextID ;  
					Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @Vendor)

				--INSERT INTO tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @Vendor);

				SET @purchaseID =@ID;
				INSERT INTO  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2,@Amount);

				EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
				set           @ID = @nextID ; 
				INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,UserName, PaymentDate, PurchaseNo,LastBalance   )
									Values(@ID,@AccountNo, @FacilityID, @ResidentIdentifier, @Amount , 7,  @Vendor, getdate(), @purchaseID, @LastBalance)	;

			
			end
		 else
			begin
				 Insert tblDebitCardOrderDup(OrderNo,FacilityID,InmateID,Amount,clientID )
						 values(@RequestID,@FacilityID,@ResidentIdentifier,@Amount, @ClientType );
			end 


	end

		select @Replystatus as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@Amount  as Amount,
		@TimeStamp  as [TimeStamp]  ;
 end
else
		select '99'  as ReplyStatus,
		@RequestID as RequestID,
		@ClientType as ClientType,  -- not use
		@SystemID	as SystemID	,			--ClientID
		@SystemTag as SystemTag,  -- facilityID	int,
		@Vendor	as Vendor, --Swandons
		@ResidentIdentifier	as ResidentIdentifier,-- InmateID	Varchar(12),
		@PIN		as PIN,
		@Amount  as Amount,
		@TimeStamp  as [TimeStamp] ;
 						
