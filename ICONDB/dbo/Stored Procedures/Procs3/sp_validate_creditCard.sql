


CREATE PROCEDURE [dbo].[sp_validate_creditCard]
@CardNo	varchar(16),
@CCType	varchar(1) OUTPUT,
@ANI		char(10)
 AS
Declare @CardLength  smallint , @subLength  smallint,  @total smallint , @currentNo  smallint, @localTime  varchar(8), @h int,
       @revervePos  smallint ,  @currentNoStr char(2),  @checkNo smallint, @fraudAccount  smallint , @npa  char(3), @nxx char(3), @first2Digits char(2);

SET @npa  = left(@ANI, 3);
SET @NXX= substring(@ANI,4,3) ;
SET @first2Digits = Left(@CardNo,2)
If(@first2Digits = 34  Or @first2Digits = 37)
	SET @CardNo = LEFT (@CardNo,15);
SET @CardLength = len(@CardNo);
SET  @subLength =  @CardLength;
SET  @currentNo = 0;
SET @total = 0;
SET @CCType	= '';
If ( isnumeric(@CardNo) =0) 	Return -1 ;

--EXEC @h = sp_get_local_time   @npa , @nxx , @localTime  OUTPUT
--If( @h < 3  ) return  -1

--If (select count(*) from tblTBRreject where CCNo =  @CardNo) > 0 return -1

--if (select count(*)  from tblcallsbilled with(nolock) where creditcardNo = @CardNo and  responsecode='004'  and RecordDate > = dateadd(d,-2,getdate()) ) > 1  Return -1
SELECT @CCType = CCtype  From tblCreditCard     WHERE  CCPrefix = left(@CardNo,4)  AND CCLength = @CardLength 

IF( @CCType ='' or @CCType is null ) 
	SELECT @CCType = CCtype  From tblCreditCard  with(nolock)   WHERE  CCPrefix = left(@CardNo,3)  AND CCLength = @CardLength ;
IF( @CCType =''  or @CCType is null ) 
	SELECT @CCType = CCtype  From tblCreditCard  with(nolock)   WHERE  CCPrefix = left(@CardNo,2)  AND CCLength = @CardLength;
IF( @CCType =''  or @CCType is null ) 
	Select @CCType = CCtype From tblCreditCard  with(nolock)  WHERE  CCPrefix = left(@CardNo,1)  AND CCLength = @CardLength;
IF( @CCType ='' or  @CCType is null) 
	Return -1;
--select 'test'
While (  @subLength>0) 
  Begin
	SET @currentNo = CONVERT(smallint, SUBSTRING ( @CardNo,  @subLength ,1) );
	
	SET @subLength = @subLength -1;
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
	--select   @currentNo ,  @total 
	
  End
	
	SET @checkNo = @total/10;
	If(  @checkNo * 10 = @total )
	  Begin		
		Return 	1;			
	   End
	else
	  Begin
		SET @CCType	='';
		Return -1;
	  End
