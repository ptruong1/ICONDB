
CREATE PROCEDURE [dbo].[p_commissionary_fund_Debit_restfull-NotUsed]

@Token varchar(40),
@ClientInmateAcct varchar(16),
@ClientTransID	varchar(30),
@amount numeric(7,2)

AS

declare  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Replystatus varchar(2),
@UserName varchar(20), @return_Message varchar(50), @InmateID varchar(12);
SET @facilityID =0;
set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) ))
set @return_Message = 'Invalid token'

select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 begin
	if (select count(*) FROM [leg_Icon].[dbo].[tblDebit] d 
	where D.facilityID = @facilityID and D.InmateId = @InmateID) >0
	Begin
      UPDATE [dbo].[tblDebit]
	   SET 
		  [Balance] = Balance + @amount
            
	  where facilityID = @facilityID and 
	  InmateId = @InmateID

	  select '0' as return_code
	  ,'Complete Successfull' return_message
	  ,@ClientInmateAcct as account_number
	  ,@ClientTransID as trans_id
	  ,(select RecordID from tblDebit where  facilityID = @FacilityID 
	  and InmateID = @InmateID) as transaction_id
  end
  else
  begin
	Select
	  '1' as return_code
	  ,'Incompleted, account not found' return_message
	  ,@ClientInmateAcct as account_number
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
	end

end

else ----(@facilityID = 0)
 
 begin
 Select
	
      '1' as return_code
	  ,@ClientInmateAcct as account_number
	  ,'Incomplete transaction' return_message
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
 end
 						
 


