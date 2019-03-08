
CREATE PROCEDURE [dbo].[p_prepaid_new_Acct_API]
@userID	varchar(25),
@password	varchar(25),
@clientID	varchar(10),
@siteID		int,
@siteIP		varchar(16),
@AccountNo	varchar(16),
@FirstName	VARCHAR(20),
@LastName	VARCHAR(20),  
@Email	varchar(50),
@InmateName		varchar(50)

AS
SET NoCount ON
declare  @RecordID int,@EnduserPassword varchar(20) ,@replyCode varchar(3), @status smallint , @userlevel tinyint, @state char(2),@stateID smallint,@countryID smallint, @endUserID int ;
SET @userlevel =0;
SET @status =-1;
SET @EnduserPassword = left(@FirstName,1) + right(@AccountNo ,7) ;
SET @replyCode ='000';
SET @stateID  =0;
SET @endUserID  =0;
exec p_verify_client_info_API  @userID	,  @password	,@clientID	,@siteID,@siteIP	,@replyCode	 OUTPUT,@userlevel OUTPUT;
if(LEN(@AccountNo) = 10)
begin
	select  @state = [State] from tblTPM with(nolock) where NPA =LEFT(@AccountNo,3) and NXX = SUBSTRING(@accountNO,4,3);
	select @stateID = StateID,@countryID =CountryID  from tblStates where StateCode =@state ;
end 
--select LEN(@AccountNo);

if( @replyCode ='000' and  @stateID > 0) 
 Begin
	If  (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@AccountNo) > 0   OR  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo   ) > 0  
		SET  @status=-2 ;  --- Account number already exist
	Else
	 Begin
	    EXEC [p_create_EndUserID] @endUserID OUTPUT
	    if(@endUserID > 0)
	     begin
			Insert  Into tblEndUsers (EndUserID , UserName , Password , Email ,SecurityQ  )
				  Values ( @endUserID,@AccountNo , @EnduserPassword,@Email,0 );
		
			
	    end 
	    if(@@ERROR =0)
	     begin
			Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,State , StateID,CountryID )
			Values(  @AccountNo, @FirstName, @LastName,  0,1,@siteID,@endUserID,@clientID, @InmateName,@state ,@stateID,@CountryID);
			SET @status =1;
		 end
		
	 End
	
 End

SELECT @replyCode as Authcode ,  @AccountNo as AccountNumber ,  @status  as Status ;
Return 0;
