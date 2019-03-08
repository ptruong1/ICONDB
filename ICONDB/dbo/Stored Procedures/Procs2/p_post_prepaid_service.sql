
CREATE PROCEDURE [dbo].[p_post_prepaid_service]
@agentID int

 AS

Declare @FacilityID int ,  @AccountNo	char(10), @Amount numeric(7,2) ,  @currentDate  datetime , @LastDate datetime, @YYYY  int , @MM smallint ,  @HH smallint , @Mi  smallint ,@dd smallint, @FileName  varchar(30) , @file_dir  varchar(30),
	 @s_MM  char(2), @s_HH char(2), @s_Mi  char(2), @s_YYYY char(4) ,@cmd varchar(500), @s_dd char(2),  @SS smallint ,  @s_SS char(2)

SET  @currentDate = getDate()
SET  @YYYY = datepart( YYYY, @currentDate)
SET  @s_YYYY = CAST(@YYYY as char(4))
SET   @MM = datepart(MM,@currentDate)
If(  @MM < 10) SET @s_MM = '0' + CAST( @MM as char(1))
Else  SET @s_MM = CAST(@MM  as char(2))

SET   @dd = datepart(d,@currentDate)
If(  @dd < 10) SET @s_dd = '0' + CAST( @dd as char(1))
Else  SET @s_dd = CAST(@dd  as char(2))

SET @HH =  datepart(HH, @currentDate)
If(  @HH < 10) SET @s_HH = '0' + CAST(@HH as char(1))
Else  SET @s_HH = CAST(@HH  as char(2))

SET  @Mi =   datepart(Mi,@currentDate)
If(  @Mi  < 10) SET @s_Mi = '0' + CAST(@Mi as char(1))
Else  SET @s_Mi = CAST(@Mi  as char(2))

SET  @SS =   datepart(SS,@currentDate)
If(  @SS  < 10) SET @s_SS = '0' + CAST(@SS as char(1))
Else  SET @s_SS = CAST(@SS  as char(2))

SET @FacilityID = 0
--SET  @LastDate = '3/17/2010'
SET  @LastDate =  (select top 1  paymentDate from  tblTempPrepaidService with(nolock)    Order by  paymentDate DESC)
--SET  @LastDate =  '3/17/2010'
If (select count(*) from  tblPrepaidPaymentSerVice  with(nolock)  where     PaymentDate> @LastDate ) > 0
Begin
	Delete  tblTempPrepaidService
	Insert   tblTempPrepaidService (facilityName ,  PhoneNo,    UsageAmt, ServiceFee, SalesTax,SalesTaxRate ,TotalCharge, OrderID , CCname,  CCNo    ,  CCExpMonth, CCExpYear, CCcvv, CCAddresNo ,  CCzip, paymentDate )                                           

	
	select Location,AccountNo , cast(Amount as varchar(7)), cast(ProcessFee as varchar(7)), cast(Tax as varchar(7)), cast(Cast(Tax/Amount as numeric(6,4)) as varchar(7)), cast( CAST( (SetupFee + ProcessFee + Tax +Amount ) AS Numeric(8,2))  as varchar(7)),
		cast (paymentID as  varchar(10) ),  ltrim(CCFirstName ) + ' ' + ltrim(CCLastName)  , CCNo,left(CCExp,2) , '20' + right(CCExp,2) ,CCcode, CCAddress,   CCzip ,  PaymentDate
  		  from tblPrepaidPaymentSerVice , tblFacilityService where 
			tblFacilityService.facilityID = tblPrepaidPaymentSerVice.FacilityID and tblFacilityService.AgentID =@AgentID  and   PaymentDate> @LastDate 
			Order by PaymentDate


	SET @FileName =      @s_YYYY +  @s_MM + @s_dd + @s_HH +   @s_Mi  +   @s_SS +   '.cc.unl'

	SET  @file_dir = 'C:\1\'


	SET  @cmd =  'bcp "select  facilityName ,  PhoneNo,    UsageAmt, ServiceFee, SalesTax,SalesTaxRate ,TotalCharge, OrderID , CCName, CCNo    ,  CCExpMonth, CCExpYear, CCcvv, CCAddresNo ,  CCzip  from leg_Icon.. tblTempPrepaidService"     queryout  '  +  @file_dir  + @FileName  +    '   -c -t "|"  -SICONDB  -Usa -Pmylegacy   '
	
	
	EXEC  master.dbo.xp_cmdshell   @cmd

End 

return @@error

