
CREATE PROCEDURE [dbo].[p_commissionary_inmate_release_restfull-NotUsed]

@Token varchar(40),
@ClientInmateAcct varchar(16),
@ClientTransID	varchar(30)


AS

declare  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Replystatus varchar(2),
@UserName varchar(20), @return_Message varchar(50),  @balance as numeric(6,2), @InmateID varchar(12);
SET @facilityID =0;
set @return_Message = 'Invalid token'
set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) ))

select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 
	if (select count(*) FROM [leg_Icon].[dbo].[tblDebit] d 
	where D.facilityID = @facilityID and D.InmateId = @InmateID) >0
	begin
	Select @balance = balance, @AccountNo = AccountNo from tbldebit where facilityID = @facilityID and inmateID = @InmateID;

	update tbldebit set status = 4 , modifyDate = getdate(), Balance=0, Note='Release and Refund'  where facilityID = @facilityID and inmateID = @InmateID;
	update tblinmate set status =2  , modifyDate = getdate(),InmateNote='Release and Refund' , username='Commissionary'  where facilityID = @facilityID and inmateID = @InmateID;
	insert tblAdjustment (AdjTypeID,AccountNo, LastBalance ,AdjAmount ,Descript ,AdjustDate ,UserName ,status )
			values(7,@accountNo,@balance,@balance,'Refund Commissary',GETDATE(), 'Commissionary' ,1);
	
	  select '0' as return_code
	  ,'Complete Successfull' return_message
	  ,@ClientInmateAcct as account_number
	  ,@balance as released_amount
	  ,@ClientTransID as trans_id
	  ,(select RecordID from tblDebit where  facilityID = @FacilityID 
	  and InmateID = @inmateID) as transaction_id
	end
  else
  begin
	Select
	  '1' as return_code
	  ,'Incompleted, account not found' return_message
	  ,@ClientInmateAcct as account_number
	  ,0 as released_amount
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
	end



else ----(@facilityID = 0)
 
 begin
 Select
	
      '1' as return_code
	  ,'Incomplete transaction' return_message
	  ,@ClientInmateAcct as account_number
	  ,@balance as released_amount
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
 end
 						
 


