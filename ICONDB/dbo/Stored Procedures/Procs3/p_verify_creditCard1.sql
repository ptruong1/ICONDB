﻿CREATE PROCEDURE [dbo].[p_verify_creditCard1]
@CardNo	varchar(16),
@ANI	char(10),  -- Phone No
@AuthCode smallint OUTPUT
 AS
Declare @CardLength  smallint , @subLength  smallint,  @total smallint , @currentNo  smallint, @localTime  varchar(8), @h int,
             @revervePos  smallint ,  @currentNoStr char(2),  @checkNo smallint, @fraudAccount  smallint , @npa  char(3), @nxx	char(3), @CCType  varchar(1)

SET @npa  = left(@ANI, 3);
SET @NXX= substring(@ANI,4,3) ;

If(Left(@CardNo,2) = 34  Or Left(@CardNo,2) = 37)
	SET @CardNo = LEFT (@CardNo,15);
SET @CardLength = len(@CardNo);
SET  @subLength =  @CardLength;
SET  @currentNo = 0;
SET @total = 0;
SET @CCType	= '';
If ( isnumeric(@CardNo) =0) 
 Begin
	 SET 	@AuthCode = -1 ;
	 Return -1;

 End	


SELECT @CCType = CCtype  From tblCreditCard  WITH(NOLOCK)   WHERE  CCPrefix = left(@CardNo,4)  AND CCLength = @CardLength 

IF( @CCType ='' or @CCType is null ) 
	SELECT @CCType = CCtype  From tblCreditCard  WITH(NOLOCK)   WHERE  CCPrefix = left(@CardNo,3)  AND CCLength = @CardLength 
IF( @CCType =''  or @CCType is null ) 
	SELECT @CCType = CCtype  From tblCreditCard  WITH(NOLOCK)   WHERE  CCPrefix = left(@CardNo,2)  AND CCLength = @CardLength
IF( @CCType =''  or @CCType is null ) 
	Select @CCType = CCtype From tblCreditCard  WITH(NOLOCK)   WHERE  CCPrefix = left(@CardNo,1)  AND CCLength = @CardLength
IF( @CCType ='' or  @CCType is null) 
 Begin
	SET 	@AuthCode = -1 ;
	Return -1 ;
 End

While (  @subLength>0) 
  Begin
	SET @currentNo = CONVERT(smallint, SUBSTRING ( @CardNo,  @subLength ,1) );
	
	SET @subLength = @subLength -1 ;
	SET @revervePos =  @CardLength - @subLength ;
	IF(  @revervePos  = 2 Or  @revervePos =4 OR  @revervePos = 6 Or  @revervePos=8 Or  @revervePos=10 Or  @revervePos=12 Or  @revervePos =14 Or  @revervePos =16 ) 
	  Begin	 
		SET @currentNo = @currentNo * 2;
		If ( @currentNo >= 10 )
		  Begin
			SET @currentNoStr = CONVERT(char(2), @currentNo);
			SET @currentNo = CONVERT(smallint, LEFT(@currentNoStr ,1) ) +  CONVERT(smallint, Right(@currentNoStr ,1) );
		  End
	  End
	SET @total = @total + @currentNo;
	
	
  End
	
SET @checkNo = @total/10
If(  @checkNo * 10 = @total )
  Begin
	declare @i int;
	exec  @i= p_Credit_Card_Threshold  @CardNo	
	If ( @i = -2)
	 Begin
		 SET 	@AuthCode = -1 ;
		 return  -2;
	 End
	 if(select count(*) from  tblprepaidPayments where CCNO =  @CardNo  and AccountNo = @ANI ) > 0
	 begin
		 SET 	@AuthCode = 1 ;
		Return 	1;
	 end
	Else if(select count(*) from  tblprepaidPayments where CCNO =  @CardNo  and AccountNo <> @ANI ) > 1
	 begin
		 SET 	@AuthCode = 0 ;
		 Return 	0 ;
	 end
	else
	  begin
		SET 	@AuthCode = 1 ;
		Return 	1;
	 end
		
   End
else
  Begin
	SET @CCType	=''
	SET 	@AuthCode = -1 ;
	Return -1
  End
