CREATE PROCEDURE [dbo].[p_get_prepaid_Acct_Info_API]
@userID	varchar(25),
@password	varchar(25),
@clientID	varchar(10),
@siteID		int,
@siteIP		varchar(16),
@AccountNo	varchar(16)
 AS
Declare @balance  numeric(8,2), @status varchar(25) , @replyCode char(3), @FirstName  varchar(25),  @LastName  varchar(25)  ,@userlevel  tinyint
SET nocount on
set @balance =0
set @status =0
SET @replyCode ='000'
SET @FirstName='NotFound'
SET @LastName ='NotFound'

exec p_verify_client_info_API  @userID	,  @password	,@clientID	,@siteID,@siteIP	,@replyCode	 OUTPUT,@userlevel OUTPUT

if( @replyCode ='000' or @replyCode ='200' ) 
 begin
	select   @balance= P.balance, @status =S.Descrip ,@FirstName = P.FirstName,  @LastName= P.lastName  from tblprepaid  P with(nolock) , tblStatus  S with(nolock)  where P.status = S.statusID  AND   P.phoneno = @AccountNo 
 end
Select   @replyCode as AuthCode,  @AccountNo as AccountNumber , @FirstName as FirstName, @LastName as LastName, @status as Status,@balance as AccountBalance
