
CREATE PROCEDURE [dbo].[p_commissionary_Get_Debit_Record_restfull]

@Token varchar(40),
@ClientInmateAcct varchar(20),
@ClientTransID	varchar(30)
AS

declare  @transaction_id bigint, @facilityID  int,  @AccountNo varchar(12), @Suspended tinyint,
@UserName varchar(20), @return_Message varchar(50), @InmateID varchar(12);
SET @facilityID =0;
set @InmateID = LTRIM(RIGHT(@ClientInmateAcct,LEN(@ClientInmateAcct) - CHARINDEX('-',@ClientInmateAcct) ))
--set @InmateID = REPLACE(@ClientInmateAcct, '-', '');
set @return_Message = 'Invalid token';

select @facilityID = facilityID, @userName =userID from tblAPIToken with(nolock) where token= @Token;

if(@facilityID >0)
 begin
	if (select count(*) FROM [leg_Icon].[dbo].[tblDebit] d 	where D.facilityID = @facilityID and D.InmateId = @InmateID) >0
	Begin
	SELECT       
      @ClientInmateAcct as account_number      
	  ,@InmateID as inmate_number
	  ,I.PIN as pin
      ,I.firstName as first_name
      ,I.lastname as last_name
		,Isnull(I.dob,'') as dob
      ,'' as location
      ,[Balance] as available_balance
      ,case when d.status = 1 then 1 else 0 end as active
      ,case when d.status = 1 then 0 else 1 end  as suspended
      ,'0' as return_code
	  ,'Completed successfully' return_message
	  ,@ClientTransID as trans_id
	  ,recordId as transaction_id
		FROM [leg_Icon].[dbo].[tblDebit] d
	 join [leg_Icon].[dbo].tblinmate I on I.facilityid = D.facilityId and I.inmateID = D.inmateID
	 where D.facilityID = @facilityID and D.InmateId = @InmateID ;
  end
  else
  begin
	Select
		@ClientInmateAcct as account_number
      ,@InmateID as inmate_number
	  ,'' as pin
      ,'' as first_name
      ,'' as last_name
		,'' as dob
     ,'' as location
      ,0 as available_balance
      
      ,0 as active
      ,0 as suspended
      ,'1' as return_code
	  ,'Incompleted, account not found' return_message
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
  end

end

else ----(@facilityID = 0)
 
 begin
 Select
		@ClientInmateAcct as account_number
      ,@InmateID
	  ,'' as pin
      ,'' as first_name
      ,'' as last_name
		,'' as dob
     ,'' as location
      ,0 as available_balance
      
      ,0 as active
      ,0 as suspended
      ,'1' as return_code
	  ,@return_Message as return_message
	  ,@ClientTransID as trans_id
	  ,'' as transaction_id
 end
 						
 


