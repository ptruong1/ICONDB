
CREATE PROCEDURE [dbo].[p_commissary_inmate_release_restfull]

@Token varchar(40),
@ClientInmateAcct varchar(16),
@ClientTransID	varchar(30)


AS

declare  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Replystatus varchar(2), @balance_v varchar(10),
@UserName varchar(20), @return_Message varchar(50),  @balance as numeric(6,2), @InmateID varchar(12), @return_code varchar(1);
SET @facilityID =0;
set @return_Message = 'Invalid token';
set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) ));
--SET @InmateID = replace (@ClientInmateAcct,'-','');
SET @return_code ='1';
select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 Begin 
	if (select count(*) FROM [leg_Icon].[dbo].[tblDebit] 	where facilityID = @facilityID and InmateId = @InmateID) >0
	begin
		Select @balance = balance, @AccountNo = AccountNo from tbldebit where facilityID = @facilityID and inmateID = @InmateID;

		update tbldebit set status = 4 , modifyDate = getdate(), Balance=0, Note='Release and Refund'  where facilityID = @facilityID and inmateID = @InmateID;
		update tblinmate set status =2  , modifyDate = getdate(),InmateNote='Release and Refund' , username= @userName where facilityID = @facilityID and inmateID = @InmateID;
		Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
		EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
             set           @ID = @nextID ; 
		insert tblAdjustment (AdjID, AdjTypeID,AccountNo, LastBalance ,AdjAmount ,Descript ,AdjustDate ,UserName ,status )
				values(@ID, 7,@accountNo,@balance,@balance,'Release Commissary',GETDATE(), @userName ,1);
	    SET @transaction_id  = @ID;

	end
	else
	 begin
		SET @return_code ='1';
		SET @return_Message ='Incompleted, account not found' ;
	 end
 End 
SET  @balance_v = Cast(@balance as varchar(10));
EXEC p_API_call  @ClientTransID ,'Token'	,@userName	,@facilityID ,@userName	,@InmateID	,''		,'' ,6,  @balance_v;						
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

  select  @return_code as return_code
		  ,@return_Message return_message
		  ,@ClientInmateAcct as account_number
		  ,@balance as released_amount
		  ,@ClientTransID as trans_id
		  ,@transaction_id as transaction_id ;

