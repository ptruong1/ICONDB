
CREATE PROCEDURE [dbo].[p_post_prepaid]

 AS

Declare @FacilityID int ,  @AccountNo	char(10), @Amount numeric(7,2) ,  @currentDate  datetime , @LastDate datetime, @YYYY  int , @MM smallint ,  @HH smallint , @Mi  smallint ,@dd smallint, @FileName  varchar(30) , @file_dir  varchar(30),
	 @s_MM  char(2), @s_HH char(2), @s_Mi  char(2), @s_YYYY char(4) ,@cmd varchar(500), @s_dd char(2)

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

SET @FacilityID = 0

SET  @LastDate =  (select top 1  paymentDate from tblTempPrepaidPayment with(nolock)    Order by  paymentDate DESC)

If (select count(tblPrepaidPayments.AccountNo ) from . tblPrepaidPayments ,tblPrepaid  with(nolock)  where   tblPrepaidPayments.AccountNo = tblPrepaid.phoneNo AND  tblPrepaid.facilityID =27 AND    paymentDate > @LastDate ) > 0
Begin
	Delete  tblTempPrepaidPayment
	Insert   tblTempPrepaidPayment 
	
	select  tblPrepaid.FacilityID , AccountNo ,   tblPurchaseDetail.Amount , paymentDate  from tblPrepaidPayments  with(nolock) ,tblPrepaid  with(nolock)  ,tblPurchaseDetail  with(nolock)
	where tblPrepaidPayments.AccountNo = tblPrepaid.phoneNo AND
	      tblPrepaidPayments.PurchaseNo = tblPurchaseDetail.PurchaseNo AND
	      tblPurchaseDetail.DetailType=2 	AND
	     tblPrepaid.facilityID =27  AND  --- For Hampton roal Only
	     paymentDate > @LastDate 
	
	     order by  paymentDate




 -- select  'hampton|PREPAID|', AccountNo, '|ENABLED|' , left(Amount,len(Amount)) , '|CK|Check cleared|'  from leg_Icon..tblTempPrepaidPayment



	SET @FileName = 'prepaid'  +   @s_YYYY +  @s_MM + @s_dd + @s_HH +   @s_Mi  +   '.debit.soap'

	SET  @file_dir = 'C:\27\'


	SET  @cmd =  'bcp "select  ''hampton|PREPAID|'', AccountNo, ''|ENABLED|'' , left(Amount,len(Amount)) , ''|CK|Check cleared|''  from leg_Icon..tblTempPrepaidPayment"     queryout  '  +  @file_dir  + @FileName  +    '   -c -t  -SICONDB_SERVER  -Usa -Pmylegacy   '
	--select  'hampton|PREPAID|', AccountNo, '|ENABLED|' , left(Amount,len(Amount)) , '|CK|Check cleared|'  from leg_Icon..tblTempPrepaidPayment
	EXEC  master.dbo.xp_cmdshell   @cmd

End 

return @@error
