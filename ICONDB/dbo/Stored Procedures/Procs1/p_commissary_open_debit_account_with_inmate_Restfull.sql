
CREATE PROCEDURE [dbo].[p_commissary_open_debit_account_with_inmate_Restfull]
@Token varchar(40),
@ClientInmateAcct varchar(14),
@InmateID	varchar(12),
@PIN		varchar(12),
@FirstName  varchar(25),
@LastName   varchar(25),
@DOB		varchar(10),
@Location  varchar(30),
@Suspend	int,
@ClientTransID	varchar(30)
AS

declare @i int,@UserName varchar(20),  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Replystatus varchar(2),
 @DebitStatus tinyint, @InmateStatus tinyint, @commPIN varchar(12), @return_Message varchar(50), @return_code char(1);
  Declare @return_value int, @nextID int, @ID int, @tblpurchase nvarchar(32),@tblDebitPayments nvarchar(32), @tblDebit nvarchar(32) ;
SET @facilityID =0;
SET @DebitStatus =0;
set @InmateStatus = 0;
set @return_Message = 'Invalid token';
SET @return_code ='1';
if (@Suspend = 0)
	set @Suspend = 1;
else
	set @Suspend = 4;
select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 begin
	--SET @InmateID = right(@ClientInmateAcct,len(@ClientInmateAcct)-5);
	--SET @commPIN =  @InmateID;
	If(@facilityID = 674)
		SET @PIN = @InmateID + right(@dob,4);
	select @InmateStatus = status from  tblinmate with(nolock) where facilityID = @FacilityID and InmateID = @InmateID ;
	if @InmateStatus =0
	 begin		
		Insert tblinmate(FacilityId , InmateID , Status , FirstName , LastName , PIN , inputdate,UserName,InmateNote,DOB)
				values(@FacilityID , @InmateID , 1,@FirstName , @LastName , @PIN ,getdate(),@userName ,'' ,@DOB );
	 end
	 else
	  begin	   
			update tblinmate set  FirstName=@firstName, LastName = @LastName, PIN= @PIN, Status=1, ModifyDate=getdate()  where facilityID = @facilityID and inmateID = @InmateID;
	  end
	Select @DebitStatus=[status]  from tblDebit where  facilityID = @FacilityID and InmateID = @InmateID;
	if(@DebitStatus=0)
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
		VALUES (@ID, @AccountNo ,@facilityID,@InmateID,  getdate(), 0,0,1, @UserName, 'Commissary');

		--INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,InmateID,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
		--	VALUES (@AccountNo ,@facilityID,@InmateID, getdate(), 0,0,1, @UserName, 'Commissary');
			SET @transaction_id = @ID;
	  End
	 else
	  begin
		update tblDebit SET status=@Suspend,modifyDate= getdate()  where facilityID = @FacilityID and InmateID = @InmateID;
		SET @transaction_id = (select RecordID from tblDebit where  facilityID = @FacilityID and InmateID = @InmateID);
	  end
 end
--Log API call
EXEC p_API_call  @ClientTransID ,'Token'	,@userName	,@facilityID ,@userName	,@inmateID	,@PIN		,'' ,1,'0'						
If(@@ERROR =0 and @facilityID >0)
 begin
	SET @return_code ='0';
	SET @return_Message ='Complete Successfull' ;
 end
Else
 begin
	SET @return_code ='1';
	If(@@ERROR >0)
		SET @return_Message ='Incompleted, Error occurs' ;
 end


select  @return_code as return_code,
	    @return_message as return_message,
		@ClientInmateAcct as account_number,  
		@ClientTransID	as trans_id	,			
		@transaction_id as transaction_id  ;
		
